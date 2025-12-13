import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/models/program.dart';
import 'package:gym_app/services/auth.dart';

class ProgramService {
  final AuthService _auth = AuthService();

  String get baseUrl => _auth.baseUrl;

  // Fetch all programs (Admin/Coach view)
  Future<List<Program>> getPrograms({String? coachId, bool publicOnly = false}) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    var query = "";
    if (coachId != null) query = "?coachId=$coachId";
    if (publicOnly) query += (query.isEmpty ? "?" : "&") + "public=true";

    final url = Uri.parse("$baseUrl/programs$query");
    final res = await http.get(
      url, 
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }
    );

    if (res.statusCode == 200) {
      final List<dynamic> body = jsonDecode(res.body);
      return body.map((e) => Program.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load programs");
    }
  }

  Future<void> createProgram(Map<String, dynamic> programData) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/programs");
    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(programData),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Failed to create program: ${res.body}");
    }
  }

  Future<void> deleteProgram(String id) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/programs/$id");
    final res = await http.delete(
      url,
      headers: { "Authorization": "Bearer $token" },
    );

    if (res.statusCode != 204) throw Exception("Failed to delete program");
  }
}
