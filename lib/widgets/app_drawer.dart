import 'package:flutter/material.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/screens/progress_screen.dart';
import 'package:gym_app/screens/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = serviceLocator<AuthService>();
    // TODO: Ideally fetch user name from service (add it to auth service or user service)
    // For now, hardcoded or use email if available
    
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            accountName: const Text("User"), // Placeholder
            accountEmail: const Text("user@gym.com"), // Placeholder
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text("Workout Tracker"),
            onTap: () {
               // Usually linked from ActiveProgram, but direct access is fine
               // For now, maybe just show Progress since Tracker needs assignment context
               Navigator.pushReplacementNamed(context, '/home'); // Tracker requires context
            },
          ),
           ListTile(
            leading: const Icon(Icons.show_chart),
            title: const Text("Progress"),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()));
            },
          ),
           ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              auth.logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
