import 'package:flutter/material.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/view_models/login_model.dart';
import 'package:gym_app/widgets/button.dart';
import 'package:gym_app/widgets/textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final LoginViewModel vm = serviceLocator<LoginViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_open_rounded, size: 100),
            const SizedBox(height: 10),

            Text(
              "Food delivery App",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 25),

            CustomTextField(
              controller: email,
              hintText: "Email",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: password,
              hintText: "Password",
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Error message
            ValueListenableBuilder<String?>(
              valueListenable: vm.error,
              builder: (context, errorText, _) {
                if (errorText == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    errorText,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
            ),

            ValueListenableBuilder<bool>(
              valueListenable: vm.isLoading,
              builder: (_, isLoading, _) {
                return CustomButton(
                  text: isLoading ? "Loading..." : "Sign In",
                  onTap: () async {
                    try {
                      await vm.login(email.text, password.text);
                      Navigator.pushReplacementNamed(context, '/home');
                    } catch (e) {
                      // Handle login error
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    "Register Now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
