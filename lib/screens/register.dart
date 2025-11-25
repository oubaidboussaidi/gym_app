import 'package:flutter/material.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/view_models/register_model.dart';
import 'package:gym_app/widgets/button.dart';
import 'package:gym_app/widgets/textfield.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController username = TextEditingController();

  final RegisterViewModel vm = serviceLocator<RegisterViewModel>();

  void register() async {
    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    if (email.text.isEmpty || password.text.isEmpty || username.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await vm.register(email.text, password.text, username.text);

    if (vm.isRegistered.value && mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
              Icons.fitness_center_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              "Join The Club",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
              const SizedBox(height: 25),
              CustomTextField(
                controller: username,
                hintText: "Username",
                obscureText: false,
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              CustomTextField(
                controller: confirmPassword,
                hintText: "Confirm Password",
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Error message
              ValueListenableBuilder<String?>(
                valueListenable: vm.error,
                builder: (context, errorText, _) {
                  if (errorText == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
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
                    text: isLoading ? "Loading..." : "Sign Up",
                    onTap: register,
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      "Login Now",
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
      ),
    );
  }
}
