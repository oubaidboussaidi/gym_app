import 'package:flutter/foundation.dart';
import 'package:gym_app/services/auth.dart';

class AuthViewModel {
  final AuthService _authService;
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  AuthViewModel(this._authService);

  Future<void> init() async {
    isLoading.value = true;
    await _authService.loadToken();
    isLoggedIn.value = _authService.isLoggedIn;
    isLoading.value = false;
  }

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    try {
      await _authService.login(username, password);
      isLoggedIn.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _authService.logout();
    isLoggedIn.value = false;
  }
}
