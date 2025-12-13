import 'package:flutter/material.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/screens/admin/user_management_screen.dart'; // Import

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AuthService _auth = AuthService();

  void _logout() {
    _auth.logout();
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
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(Icons.people, "Manage Users", Colors.blue, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementScreen()));
          }),
          _buildCard(Icons.fitness_center, "Exercise DB", Colors.orange, () {
            // TODO: Navigate to Exercise Management
          }),
          _buildCard(Icons.analytics, "System Stats", Colors.purple, () {
            // TODO: Navigate to Stats
          }),
          _buildCard(Icons.settings, "Settings", Colors.grey, () {
            // TODO: Navigate to Settings
          }),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
