import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:gym_app/models/program.dart';
import 'package:gym_app/models/workout_log.dart';
import 'package:gym_app/services/auth.dart';

class UserService {
  final AuthService _auth = AuthService();

  String get baseUrl => _auth.baseUrl;

  Future<List<Program>> getPrograms() async {
    final url = Uri.parse("$baseUrl/programs");
    try {
      final res = await http.get(url, headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer ${_auth.token}" // Uncomment if protected
      });

      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);
        return body.map((e) => Program.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load programs");
      }
    } catch (e) {
      throw Exception("Error fetching programs: $e");
    }
  }

  Future<List<WorkoutLog>> getLogs(String userId) async {
    final url = Uri.parse("$baseUrl/logs/$userId");
    try {
      final res = await http.get(url, headers: {"Content-Type": "application/json"});
      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);
        return body.map((e) => WorkoutLog.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception("Error logs: $e");
    }
  }

  Future<void> saveLog(WorkoutLog log) async {
    final url = Uri.parse("$baseUrl/logs");
    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(log.toJson()),
      );
      if (res.statusCode != 201) throw Exception("Failed save log");
    } catch (e) {
      throw Exception("Error save log: $e");
    }
  }

  // Allow passing current stats to update
  Future<void> updateProgress(String userId, Map<String, dynamic> progression) async {
    final url = Uri.parse("$baseUrl/users/$userId");
    try {
      final res = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer ${_auth.token}"
        },
        body: jsonEncode({"progression": progression}),
      );

      if (res.statusCode != 200) {
        throw Exception("Failed to update progress");
      }
    } catch (e) {
      throw Exception("Error updating progress: $e");
    }
  }
}
