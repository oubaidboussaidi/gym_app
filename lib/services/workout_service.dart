import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_app/models/workout_session.dart';
import 'package:gym_app/services/auth.dart';

class WorkoutService {
  final AuthService _auth = AuthService();

  String get baseUrl => _auth.baseUrl;

  Future<void> saveSession(WorkoutSession session) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/logs");
    final res = await http.post(
      url, 
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(session.toJson())
    );

    if (res.statusCode != 201) {
      throw Exception("Failed to save session: ${res.body}");
    }
  }
}
