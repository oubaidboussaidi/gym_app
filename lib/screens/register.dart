import 'package:flutter/material.dart';
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

  void register() async {}

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
            const SizedBox(height: 10),
            CustomTextField(
              controller: confirmPassword,
              hintText: "Confirm Password",
              obscureText: true,
            ),
            const SizedBox(height: 10),
            CustomButton(text: "Sign Up", onTap: register),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Text(
                  "Already a member?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => {Navigator.pushNamed(context, '/login')},
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
    );
  }
}
