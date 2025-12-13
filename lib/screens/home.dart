import 'package:flutter/material.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/services/user_service.dart';
import 'package:gym_app/services/assignment_service.dart';
import 'package:gym_app/models/program_assignment.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/screens/active_program_screen.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/widgets/app_drawer.dart'; // import

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

  void _logout() {
    _auth.logout();
    if (mounted) {
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      drawer: const AppDrawer(), // Add Drawer
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Welcome Section
                Text(
                  "Welcome back,\n${_auth.username?.split(" ")[0] ?? 'Athlete'}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
      
                // Active Program Card
                if (_activeAssignment != null)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (_) => ActiveProgramScreen(assignment: _activeAssignment!)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.fitness_center, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text("ACTIVE PROGRAM", style: TextStyle(color: Colors.white.withOpacity(0.8), letterSpacing: 1.2, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                _activeAssignment!.program?.title ?? "Untitled Program",
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Week ${_activeAssignment!.currentWeek}, Day ${_activeAssignment!.currentDay}", // Assuming these fields exist in Assignment
                                style: const TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Continue Workout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                else
                   Card(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                     child: const Padding(
                       padding: EdgeInsets.all(30),
                       child: Column(
                         children: [
                           Icon(Icons.info_outline, size: 40, color: Colors.grey),
                           SizedBox(height: 10),
                           Text("No active program assigned.\nAsk your coach to assign one!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                         ],
                       ),
                     ),
                   ),
      
                const SizedBox(height: 30),
                
                // Recent Activity / Stats Placeholder
                const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(context, Icons.history, "History", Colors.purple, () {
                        // Nav to history
                      }),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildQuickAction(context, Icons.show_chart, "Progress", Colors.green, () {
                         // Nav to progress
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
