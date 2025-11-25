import 'package:flutter/foundation.dart';
import 'package:gym_app/services/auth.dart';

class RegisterViewModel {
  final AuthService _authService;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isRegistered = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);

  RegisterViewModel(this._authService);

  Future<void> register(String email, String password, String username) async {
    isLoading.value = true;
    error.value = null;
    try {
      await _authService.register(email, password, username);
      isRegistered.value = true;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
