import 'package:flutter/material.dart';
import 'package:gym_app/models/workout_session.dart';
import 'package:gym_app/services/workout_service.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/service_locator.dart';

class TrackerScreen extends StatefulWidget {
  final Map<String, dynamic> dayStructure;
  final String assignmentId;
  final int weekNumber;
  final int dayNumber;

  const TrackerScreen({
    super.key, 
    required this.dayStructure, 
    required this.assignmentId,
    required this.weekNumber,
    required this.dayNumber,
  });

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final AuthService _auth = serviceLocator<AuthService>();
  final WorkoutService _workoutService = WorkoutService();
  
  // State: Map of Exercise Index -> List of SetLogs
  // We initialize this from the target structure (if we want pre-fill)
  final Map<int, List<SetLog>> _logs = {}; 

  @override
  void initState() {
    super.initState();
    // Initialize logs structure based on targets
    final exercises = (widget.dayStructure['exercises'] as List<dynamic>?) ?? [];
    for (int i = 0; i < exercises.length; i++) {
       _logs[i] = [];
       // Optionally pre-fill with defaults based on targetSets? 
       // For now start empty.
    }
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      _logs[exerciseIndex]!.add(SetLog(
        setNumber: _logs[exerciseIndex]!.length + 1,
        weight: 0,
        reps: 0,
        rpe: 0
      ));
    });
  }

  Future<void> _finishWorkout() async {
    // Validate?
    // Construct Session
    final exercises = (widget.dayStructure['exercises'] as List<dynamic>?) ?? [];
    List<ExerciseLog> exerciseLogs = [];

    _logs.forEach((index, sets) {
       if (index < exercises.length) {
         final exData = exercises[index];
         exerciseLogs.add(ExerciseLog(
           exerciseId: exData['exerciseId'] ?? '', // Assuming ID is stored in structure
           name: exData['name']?.toString() ?? 'Unknown',
           sets: sets
         ));
       }
    });

    final session = WorkoutSession(
      userId: _auth.userId ?? '',
      assignmentId: widget.assignmentId,
      weekNumber: widget.weekNumber,
      dayNumber: widget.dayNumber,
      durationMinutes: 60, // Mock duration
      logs: exerciseLogs,
      userFeedback: "Great workout",
      userRPE: 8
    );

    try {
      await _workoutService.saveSession(session);
      if (mounted) {
         Navigator.pop(context);
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Workout Saved!")));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = (widget.dayStructure['exercises'] as List<dynamic>?) ?? [];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Log: ${widget.dayStructure['name']}")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length + 1,
        itemBuilder: (context, index) {
          if (index == exercises.length) {
             return Padding(
               padding: const EdgeInsets.only(top: 20),
               child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: theme.colorScheme.primary, 
                   padding: const EdgeInsets.all(16)
                 ),
                 onPressed: _finishWorkout, 
                 child: const Text("FINISH WORKOUT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
               ),
             );
          }

          final ex = exercises[index];
          final currentSets = _logs[index] ?? [];

          return Card(
             margin: const EdgeInsets.only(bottom: 16),
             color: theme.cardTheme.color,
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(ex['name']?.toString() ?? 'Unknown Exercise', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 5),
                   Text("Target: ${ex['targetSets'] ?? 0} x ${ex['targetReps'] ?? 'N/A'}", style: TextStyle(color: Colors.grey[400])),
                   const Divider(color: Colors.white24),
                   ...currentSets.map((set) => ListTile(
                     dense: true,
                     contentPadding: EdgeInsets.zero,
                     title: Text("Set ${set.setNumber}: ${set.weight}kg x ${set.reps}", style: const TextStyle(fontWeight: FontWeight.bold)),
                     trailing: Icon(Icons.check_circle, color: theme.colorScheme.primary),
                   )),
                   Align(
                     alignment: Alignment.centerRight,
                     child: TextButton.icon(
                       onPressed: () => _showAddSetDialog(index),
                       icon: const Icon(Icons.add),
                       label: const Text("Log Set"),
                     ),
                   )
                 ],
               ),
             ),
          );
        },
      ),
    );
  }

  void _showAddSetDialog(int index) {
     final weightCtrl = TextEditingController();
     final repsCtrl = TextEditingController();
     final rpeCtrl = TextEditingController();

     showDialog(
       context: context,
       builder: (_) => AlertDialog(
         title: const Text("Log Set"),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             TextField(controller: weightCtrl, decoration: const InputDecoration(labelText: "Weight (kg)"), keyboardType: TextInputType.number),
             TextField(controller: repsCtrl, decoration: const InputDecoration(labelText: "Reps"), keyboardType: TextInputType.number),
             TextField(controller: rpeCtrl, decoration: const InputDecoration(labelText: "RPE (1-10)"), keyboardType: TextInputType.number),
           ],
         ),
         actions: [
           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
           TextButton(onPressed: () {
              final w = double.tryParse(weightCtrl.text) ?? 0;
              final r = int.tryParse(repsCtrl.text) ?? 0;
              final rpe = int.tryParse(rpeCtrl.text) ?? 0;
              
              setState(() {
                 _logs[index]!.add(SetLog(
                   setNumber: _logs[index]!.length + 1,
                   weight: w,
                   reps: r,
                   rpe: rpe
                 ));
              });
              Navigator.pop(context);
           }, child: const Text("Save")),
         ],
       )
     );
  }
}
