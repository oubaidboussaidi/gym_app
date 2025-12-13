import 'package:flutter/material.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/screens/coach/my_athletes_screen.dart';
import 'package:gym_app/screens/coach/program_builder_screen.dart'; // Import

class CoachDashboard extends StatefulWidget {
  const CoachDashboard({super.key});

  @override
  State<CoachDashboard> createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  final AuthService _auth = AuthService();

  void _logout() async {
    await _auth.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coach Dashboard"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            "My Athletes",
            [
              _buildActionTile(Icons.person_add, "My Athletes / Assign Program", () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const MyAthletesScreen()));
              }),
              _buildActionTile(Icons.rate_review, "Review Logs", () {}),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            "Program Management",
            [
              _buildActionTile(Icons.add_circle, "Create New Program", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgramBuilderScreen()));
              }),
              _buildActionTile(Icons.library_books, "View Library", () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
