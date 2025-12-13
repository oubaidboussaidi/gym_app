import 'package:flutter/material.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/service_locator.dart';
// import 'package:gym_app/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = serviceLocator<AuthService>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _oldPassCtrl = TextEditingController();
  final TextEditingController _branchesCtrl = TextEditingController(); // For password change

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = _auth.username ?? "";
    _emailCtrl.text = "user@example.com"; // Placeholder, AuthService needs to expose email
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailCtrl,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement update profile
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated (Simulation)")));
              },
              child: const Text("Save Changes"),
            ),
            const Divider(height: 50),
            const Text("Change Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
             TextField(
              controller: _oldPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password", prefixIcon: Icon(Icons.lock_outline)),
            ),
             const SizedBox(height: 20),
             OutlinedButton(
               onPressed: () {
                 // TODO: Implement password change
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password Updated (Simulation)")));
               },
               child: const Text("Update Password"),
             )
          ],
        ),
      ),
    );
  }
}
