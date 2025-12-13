import 'package:flutter/material.dart';
import 'package:gym_app/models/program.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/services/program_service.dart';
import 'package:gym_app/services/assignment_service.dart';

class AssignProgramScreen extends StatefulWidget {
  final User athlete;
  const AssignProgramScreen({super.key, required this.athlete});

  @override
  State<AssignProgramScreen> createState() => _AssignProgramScreenState();
}

class _AssignProgramScreenState extends State<AssignProgramScreen> {
  final ProgramService _programService = ProgramService();
  final AssignmentService _assignmentService = AssignmentService();

  List<Program> _programs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  Future<void> _loadPrograms() async {
    setState(() => _isLoading = true);
    try {
      // Coach can assign any public program or their own
      final programs = await _programService.getPrograms(); 
      setState(() {
        _programs = programs;
        _isLoading = false;
      });
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      setState(() => _isLoading = false);
    }
  }

  Future<void> _assign(Program program) async {
    try {
      await _assignmentService.assignProgram(widget.athlete.id, program.id);
      if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Assigned ${program.title} to ${widget.athlete.firstName}")));
          Navigator.pop(context);
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Assignment failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assign Program to ${widget.athlete.firstName}")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _programs.isEmpty
            ? const Center(child: Text("No programs available. Create one first!"))
            : ListView.builder(
                itemCount: _programs.length,
                itemBuilder: (ctx, i) {
                  final prog = _programs[i];
                  return Card(
                    child: ListTile(
                      title: Text(prog.title),
                      subtitle: Text(prog.level),
                      trailing: ElevatedButton(
                        child: const Text("Assign"),
                        onPressed: () => _assign(prog),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
