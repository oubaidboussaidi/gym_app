import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/program.dart';

class ProgramService {
  final String baseUrl = "http://10.0.2.2:3000";

  Future<List<Program>> getPrograms() async {
    final response = await http.get(Uri.parse('$baseUrl/programs'));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Program.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load programs');
    }
  }

  Future<Program> createProgram(Program program) async {
    final response = await http.post(
      Uri.parse('$baseUrl/programs'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(program.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Program.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create program');
    }
  }
}
