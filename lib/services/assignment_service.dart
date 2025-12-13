import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_app/models/program_assignment.dart';
import 'package:gym_app/services/auth.dart';

class AssignmentService {
  final AuthService _auth = AuthService();

  String get baseUrl => _auth.baseUrl;

  Future<ProgramAssignment?> getMyActiveAssignment() async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/my-assignment");
    final res = await http.get(
      url, 
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }
    );

    if (res.statusCode == 200) {
      return ProgramAssignment.fromJson(jsonDecode(res.body));
    } else if (res.statusCode == 404) {
      return null; // No active assignment
    } else {
      throw Exception("Failed to load assignment: ${res.body}");
    }
  }

  // Assign Program (For Coaches)
  Future<void> assignProgram(String userId, String programId) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/assignments");
    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "userId": userId,
        "programId": programId
      })
    );

    if (res.statusCode != 201) {
      throw Exception("Failed to assign program: ${res.body}");
    }
  }
}
