import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/models/program.dart';
import 'package:gym_app/services/auth.dart';

class ProgramService {
  final AuthService _auth = AuthService();

  String get baseUrl => _auth.baseUrl;

  // Fetch all exercises from library
  Future<List<Exercise>> getExercises() async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/exercises");
    final res = await http.get(
      url, 
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }
    );

    if (res.statusCode == 200) {
      final List<dynamic> body = jsonDecode(res.body);
      return body.map((e) => Exercise.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load exercises");
    }
  }

  // Create a new Program (Complex)
  // We accept a raw Map for now because the Program model logic might need updates to handle creation structure
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
}
