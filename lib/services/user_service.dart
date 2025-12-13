import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_app/models/program.dart';
import 'package:gym_app/models/workout_session.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/services/auth.dart';

class UserService {
  final AuthService _auth = AuthService();

  String get baseUrl => _auth.baseUrl;

  Future<List<Program>> getPrograms() async {
    final url = Uri.parse("$baseUrl/programs");
    try {
      final res = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);
        return body.map((e) => Program.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load programs: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching programs: $e");
    }
  }

  Future<List<WorkoutSession>> getLogs(String userId) async {
    final url = Uri.parse("$baseUrl/logs/$userId");
    try {
      final res = await http.get(url, headers: {"Content-Type": "application/json"});
      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);
        return body.map((e) => WorkoutSession.fromJson(e)).toList(); // Requires fromJson in WorkoutSession
      }
      return [];
    } catch (e) {
      throw Exception("Error logs: $e");
    }
  }

  // Legacy saveLog removed. Use WorkoutService.

  Future<void> updateProgress(String userId, Map<String, dynamic> progression) async {
    final url = Uri.parse("$baseUrl/users/$userId");
    try {
      final res = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"progression": progression}),
      );

      if (res.statusCode != 200) throw Exception("Failed to update progress");
    } catch (e) {
      throw Exception("Error updating progress: $e");
    }
  }

  // --- Admin/Coach Methods ---

  Future<List<User>> getAllUsers({String? coachId}) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    var urlString = "$baseUrl/users";
    if (coachId != null) {
      urlString += "?coachId=$coachId";
    }

    final url = Uri.parse(urlString);
    final res = await http.get(
      url, 
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }
    );

    if (res.statusCode == 200) {
      final List<dynamic> body = jsonDecode(res.body);
      return body.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load users: ${res.body}");
    }
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/users/$userId/role");
    final res = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({"role": newRole}),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to update role: ${res.body}");
    }
  }

  Future<void> deleteUser(String userId) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/users/$userId");
    final res = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    if (res.statusCode != 204) {
      throw Exception("Failed to delete user: ${res.body}");
    }
  }

  Future<void> createUser(String email, String password, String name) async {
    final url = Uri.parse("$baseUrl/auth/register");
    final res = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode({
        "email": email,
        "password": password,
        "firstName": name,
        "role": "user"
    }));

    if (res.statusCode != 201) throw Exception("Failed to create user: ${res.body}");
  }
}
