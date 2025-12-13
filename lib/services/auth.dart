import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

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
  String? _userId;
  String? _role;

  String? get token => _token;
  String? get username => _username;
  String? get userId => _userId;
  String? get role => _role;
  bool get isLoggedIn => _token != null;

  // Dynamic base URL based on platform
  String get baseUrl {
    if (kIsWeb) return "http://localhost:3000";
    if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2:3000"; // Android Emulator
    }
    // iOS Simulator, macOS, Windows, etc.
    return "http://localhost:3000";
  }

  /// Login
  Future<void> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");
    debugPrint("AuthService: Logging in at $url");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      
      debugPrint("AuthService: Login response ${res.statusCode} ${res.body}");

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body["token"] != null) {
        _token = body["token"];
        
        // Handle new backend structure
        if (body["user"] != null) {
          _role = body["user"]["role"];
          _userId = body["user"]["id"] ?? body["user"]["_id"]; // Store ID
          _username = body["user"]["email"]; 
          if (body["user"]["profile"] != null) {
             if (body["user"]["profile"]["firstName"] != null && body["user"]["profile"]["firstName"].toString().isNotEmpty) {
               _username = body["user"]["profile"]["firstName"];
             }
          }
        } 
        // Fallback for any legacy response
        else {
           _role = "user";
           _username = body["username"]; 
        }
        return;
      }

      throw AuthException(body["message"] ?? body["error"] ?? "Login failed");
    } catch (e) {
      debugPrint("AuthService: Login error $e");
      if (e is AuthException) rethrow;
      throw AuthException("Network error or invalid response: $e");
    }
  }

  /// Register
  Future<void> register(String email, String password, String username) async {
    final url = Uri.parse("$baseUrl/auth/register");
    debugPrint("AuthService: Registering at $url");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "firstName": username, // Map username to firstName
          "lastName": "",        // Optional
          "role": "user"         // Default role
        }),
      );

      debugPrint("AuthService: Register response ${res.statusCode} ${res.body}");

      final body = jsonDecode(res.body);

      if (res.statusCode == 201) {
        _username = username; 
        return;
      }

      throw AuthException(body["message"] ?? "Registration failed");
    } catch (e) {
      debugPrint("AuthService: Register error $e");
      if (e is AuthException) rethrow;
      throw AuthException("Network error or invalid response: $e");
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
