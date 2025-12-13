import 'package:flutter/material.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/services/user_service.dart';
import 'package:gym_app/services/assignment_service.dart';
import 'package:gym_app/models/program_assignment.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/screens/active_program_screen.dart';
import 'package:gym_app/service_locator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserService _userService = UserService();
  final AuthService _auth = serviceLocator<AuthService>(); 
  final AssignmentService _assignmentService = AssignmentService(); // Assuming IoC later, direct for now

  ProgramAssignment? _activeAssignment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final assignment = await _assignmentService.getMyActiveAssignment();
      setState(() {
        _activeAssignment = assignment;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading home data: $e");
      setState(() => _isLoading = false);
    }
  }

  void _logout() async {
    await _auth.logout();
    if (mounted) {
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${_auth.username ?? 'User'}"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout)
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Active Program Card
              if (_activeAssignment != null)
                Card(
                  color: Colors.blueAccent,
                  child: InkWell(
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (_) => ActiveProgramScreen(assignment: _activeAssignment!)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Current Program", style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 5),
                          Text(
                            _activeAssignment!.program?.title ?? "Untitled Program",
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              Text("Tap to view details", style: TextStyle(color: Colors.white)),
                              Spacer(),
                              Icon(Icons.arrow_forward, color: Colors.white)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              else
                 const Card(
                   child: Padding(
                     padding: EdgeInsets.all(20),
                     child: Text("No active program assigned. Ask your coach!"),
                   ),
                 ),

              const SizedBox(height: 20),
              
              // Recent Logs (Placeholder for now)
              const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const ListTile(
                leading: Icon(Icons.history),
                title: Text("No recent logs"),
              )
            ],
          ),
    );
  }
}
