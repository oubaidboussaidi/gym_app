import 'package:flutter/material.dart';
import 'package:gym_app/screens/programs_screen.dart';
import 'package:gym_app/screens/progress_screen.dart';
import 'package:gym_app/services/auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService(); // Singleton instance
    final username = auth.isLoggedIn ? auth.username ?? "Guest" : "Guest";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.fitness_center, color: Colors.black87),
            const SizedBox(width: 10),
            const Text('Gym App', style: TextStyle(color: Colors.black87)),
            const Spacer(),
            Text(
              username,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black87,
                child: Icon(Icons.person, color: Colors.white),
              ),
              onPressed: () {
                // Navigate to profile page (TODO)
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: Colors.grey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 100, color: Colors.black87),
            const SizedBox(height: 20),
            Text(
              'Welcome, $username!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            const Text(
              'Track your progress, log workouts, and stay motivated!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgramsScreen()));
                  },
                  icon: const Icon(Icons.run_circle, color: Colors.white),
                  label: const Text('Workouts', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()));
                  },
                  icon: const Icon(Icons.show_chart, color: Colors.white),
                  label: const Text('Progress', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
