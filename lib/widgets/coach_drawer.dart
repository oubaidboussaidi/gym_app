import 'package:flutter/material.dart';
import 'package:gym_app/screens/coach/my_athletes_screen.dart';
import 'package:gym_app/screens/coach/program_builder_screen.dart';
// import 'package:gym_app/screens/coach/my_programs_screen.dart'; // TODO: create if needed or reuse builder
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/services/auth.dart';

class CoachDrawer extends StatelessWidget {
  const CoachDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = serviceLocator<AuthService>();
    
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade800),
            accountName: const Text("Coach"),
            accountEmail: const Text("coach@gym.com"), // Placeholder
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.sports, color: Colors.blueAccent),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => Navigator.pushReplacementNamed(context, '/coach'),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("My Athletes"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyAthletesScreen())),
          ),
           ListTile(
            leading: const Icon(Icons.playlist_add),
            title: const Text("Program Builder"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgramBuilderScreen())),
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
