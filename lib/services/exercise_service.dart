import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/services/auth.dart';

class ExerciseService {
  final AuthService _auth = AuthService();

  String get baseUrl => _auth.baseUrl;

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
      throw Exception("Failed to load exercises: ${res.statusCode}");
    }
  }

  Future<void> createExercise(Exercise exercise) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/exercises");
    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
          "name": exercise.name,
          "category": exercise.category,
          "description": exercise.description,
          "equipment": exercise.equipment,
          // "videoUrl": exercise.videoUrl 
      }),
    );

    if (res.statusCode != 201) throw Exception("Failed to create exercise: ${res.body}");
  }

  Future<void> updateExercise(String id, Exercise exercise) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/exercises/$id");
    final res = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
          "name": exercise.name,
          "category": exercise.category,
          "description": exercise.description,
          "equipment": exercise.equipment,
      }),
    );

    if (res.statusCode != 200) throw Exception("Failed to update exercise: ${res.body}");
  }

  Future<void> deleteExercise(String id) async {
    final token = _auth.token;
    if (token == null) throw Exception("Not authenticated");

    final url = Uri.parse("$baseUrl/exercises/$id");
    final res = await http.delete(
      url,
      headers: { "Authorization": "Bearer $token" },
    );

    if (res.statusCode != 204) throw Exception("Failed to delete exercise: ${res.body}");
  }
}
