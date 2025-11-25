import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  final String baseUrl = "http://10.0.2.2:3000";

  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> getUserById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> updateUser(String id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
