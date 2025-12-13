import 'package:flutter/material.dart';
import 'package:gym_app/models/program.dart';
import 'package:gym_app/services/user_service.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  final UserService _userService = UserService();
  Future<List<Program>>? _programsFuture;

  @override
  void initState() {
    super.initState();
    _programsFuture = _userService.getPrograms();
  }

  void _showProgramDetails(BuildContext context, Program program) {
    // Legacy view: just showing basic details.
    // Structure is now complex, so we just show title/desc.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
             const SizedBox(height: 20),
             Text(program.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center),
             Text(program.level, style: const TextStyle(fontSize: 16, color: Colors.blueAccent), textAlign: TextAlign.center),
             const SizedBox(height: 20),
             Text(program.description, style: const TextStyle(fontSize: 14)),
             const Spacer(),
             const Text("To start this program, ask your coach to assign it to you!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("All Programs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: FutureBuilder<List<Program>>(
        future: _programsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No programs found."));

          final programs = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: programs.length,
            itemBuilder: (context, index) {
              final program = programs[index];
              return GestureDetector(
                onTap: () => _showProgramDetails(context, program),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.flash_on, color: Colors.orange, size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text(program.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text(program.level, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
