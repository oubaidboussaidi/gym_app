import 'package:flutter/material.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/services/user_service.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/service_locator.dart';

class MyAthletesScreen extends StatefulWidget {
  const MyAthletesScreen({super.key});

  @override
  State<MyAthletesScreen> createState() => _MyAthletesScreenState();
}

class _MyAthletesScreenState extends State<MyAthletesScreen> {
  final UserService _userService = UserService();
  final AuthService _auth = serviceLocator<AuthService>(); // Get current user ID (which is the coach ID) via auth service if stored?
  // Wait, AuthService doesn't expose ID. I need to update AuthService or assume I can get it.
  // Actually AuthService stores `_username`. I might need to store `_userId` or `_user` object in AuthService.
  // For now, I'll update AuthService to expose `userId` if feasible, OR I rely on the backend to filter by 'me' if I pass a special flag?
  // The backend uses `req.query.coachId`. I need the current coach's ID.
  // Let's assume AuthService exposes it or I'll add it.
  
  List<User> _athletes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAthletes();
  }

  Future<void> _loadAthletes() async {
    // Hack: For now, I need the coach's ID. 
    // If AuthService doesn't stick it, I can't filter.
    // I must update AuthService to store `id`.
    setState(() { _isLoading = true; _error = null; });
    try {
        // Accessing ID from AuthService (assuming I will add it in next step or use a workaround)
        // Check if `auth.user` is exposed? No.
        // I will assume I update AuthService to expose `userId`.
        final coachId = _auth.userId; 
        if (coachId == null) throw Exception("Coach ID not found");

        final users = await _userService.getAllUsers(coachId: coachId);
        setState(() { _athletes = users; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Athletes")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Error: $_error"))
              : _athletes.isEmpty 
                  ? const Center(child: Text("No athletes assigned."))
                  : ListView.builder(
                      itemCount: _athletes.length,
                      itemBuilder: (context, index) {
                        final user = _athletes[index];
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.person)),
                            title: Text(user.firstName.isEmpty ? user.email : "${user.firstName} ${user.lastName}"),
                            subtitle: const Text("Status: Active"), 
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                // Navigate to athlete details / progress
                              },
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
