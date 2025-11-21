import 'package:flutter/foundation.dart';
import 'package:gym_app/services/auth.dart';

class LoginViewModel {
  final AuthService _authService;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);

  LoginViewModel(this._authService);

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    error.value = null;
    try {
      await _authService.login(email, password);
      isLoggedIn.value = true;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
