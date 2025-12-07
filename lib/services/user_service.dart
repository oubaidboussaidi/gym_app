import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:gym_app/models/program.dart';
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
