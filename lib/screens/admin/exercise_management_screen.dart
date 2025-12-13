import 'package:flutter/material.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/services/exercise_service.dart';

class ExerciseManagementScreen extends StatefulWidget {
  const ExerciseManagementScreen({super.key});

  @override
  State<ExerciseManagementScreen> createState() => _ExerciseManagementScreenState();
}

class _ExerciseManagementScreenState extends State<ExerciseManagementScreen> {
  final ExerciseService _exerciseService = ExerciseService();
  List<Exercise> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() => _isLoading = true);
    try {
      final exs = await _exerciseService.getExercises();
      setState(() {
        _exercises = exs;
        _isLoading = false;
      });
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteExercise(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Exercise"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      )
    );

    if (confirm == true) {
      try {
        await _exerciseService.deleteExercise(id);
        _loadExercises();
      } catch (e) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete: $e")));
      }
    }
  }

  void _showEditDialog({Exercise? exercise}) {
    final nameCtrl = TextEditingController(text: exercise?.name ?? "");
    final catCtrl = TextEditingController(text: exercise?.category ?? "chest");
    final descCtrl = TextEditingController(text: exercise?.description ?? "");
    final equipCtrl = TextEditingController(text: exercise?.equipment ?? "none");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(exercise == null ? "Add Exercise" : "Edit Exercise"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: "Category (legs, chest...)")),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description")),
              TextField(controller: equipCtrl, decoration: const InputDecoration(labelText: "Equipment")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              try {
                final newEx = Exercise(
                  id: exercise?.id ?? "",
                  name: nameCtrl.text,
                  category: catCtrl.text.toLowerCase(),
                  description: descCtrl.text,
                  equipment: equipCtrl.text,
                );

                if (exercise == null) {
                  await _exerciseService.createExercise(newEx);
                } else {
                  await _exerciseService.updateExercise(exercise.id, newEx);
                }
                
                if (mounted) {
                  Navigator.pop(context);
                  _loadExercises();
                }
              } catch (e) {
                if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
              }
            }, 
            child: Text(exercise == null ? "Create" : "Save")
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exercises")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : ListView.builder(
            itemCount: _exercises.length,
            itemBuilder: (ctx, i) {
              final ex = _exercises[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: ListTile(
                  title: Text(ex.name),
                  subtitle: Text("${ex.category} | ${ex.equipment}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showEditDialog(exercise: ex)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteExercise(ex.id)),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
