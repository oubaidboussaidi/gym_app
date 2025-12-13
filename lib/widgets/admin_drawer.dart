import 'package:flutter/material.dart';
import 'package:gym_app/screens/admin/user_management_screen.dart';
import 'package:gym_app/screens/admin/exercise_management_screen.dart';
import 'package:gym_app/screens/admin/program_management_screen.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/services/auth.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = serviceLocator<AuthService>();
    
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.redAccent.shade700),
            accountName: const Text("Admin"),
            accountEmail: const Text("admin@gym.com"), // Placeholder
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.security, color: Colors.redAccent),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => Navigator.pushReplacementNamed(context, '/admin'),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Manage Users"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementScreen())),
          ),
           ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text("Exercise Database"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExerciseManagementScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text("Program Management"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgramManagementScreen())),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
