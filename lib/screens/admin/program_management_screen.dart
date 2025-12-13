import 'package:flutter/material.dart';
import 'package:gym_app/models/program.dart';
import 'package:gym_app/services/program_service.dart';

class ProgramManagementScreen extends StatefulWidget {
  const ProgramManagementScreen({super.key});

  @override
  State<ProgramManagementScreen> createState() => _ProgramManagementScreenState();
}

class _ProgramManagementScreenState extends State<ProgramManagementScreen> {
  final ProgramService _programService = ProgramService();
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

  Future<void> _deleteProgram(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Program"),
        content: const Text("Are you sure? This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      )
    );

    if (confirm == true) {
      try {
        await _programService.deleteProgram(id);
        _loadPrograms();
      } catch (e) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programs")),
      // Note: Full Program editing is complex (ProgramBuilder). 
      // Admin can delete here. For Creation, maybe direct them to ProgramBuilder?
      // Or keep it simple delete/view for now.
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _programs.isEmpty
             ? const Center(child: Text("No programs found."))
             : ListView.builder(
            itemCount: _programs.length,
            itemBuilder: (ctx, i) {
              final prog = _programs[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: ListTile(
                  title: Text(prog.title),
                  subtitle: Text("${prog.level} | ${prog.structure['weeks']?.length ?? 0} weeks"),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteProgram(prog.id)),
                  onTap: () {
                      // View details dialog
                      showDialog(context: context, builder: (_) => AlertDialog(
                        title: Text(prog.title),
                        content: Text(prog.description),
                      ));
                  },
                ),
              );
            },
          ),
    );
  }
}
