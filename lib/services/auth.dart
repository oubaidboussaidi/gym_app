import 'dart:convert';
import 'package:http/http.dart' as http;

/// Throw this when auth fails
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => "AuthException: $message";
}

/// Singleton AuthService
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;
  String? _username;

  String? get token => _token;
  String? get username => _username;
  bool get isLoggedIn => _token != null;

  final String baseUrl = "http://10.0.2.2:3000"; // emulator-friendly localhost

  /// Login
  Future<void> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body["token"] != null) {
        _token = body["token"];
        _username = body["username"]; // get username from backend
        return;
      }

      throw AuthException(body["message"] ?? "Login failed");
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Network error or invalid response");
    }
  }

  /// Register
  Future<void> register(String email, String password, String username) async {
    final url = Uri.parse("$baseUrl/auth/register");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "username": username,
        }),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 201) {
        _username = username; // optionally store username after register
        return;
      }

      throw AuthException(body["message"] ?? "Registration failed");
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Network error or invalid response");
    }
  }

  /// Logout
  void logout() {
    _token = null;
    _username = null;
  }

  /// Load token from storage (future use)
  Future<void> loadToken() async {
    // TODO: implement SharedPreferences or secure storage
    _token = null;
    _username = null;
  }
}
