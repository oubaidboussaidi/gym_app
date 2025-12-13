import 'package:flutter/material.dart';
import 'package:gym_app/models/program.dart';
import 'package:gym_app/models/workout_log.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/services/user_service.dart';

class TrackerScreen extends StatefulWidget {
  final Program program;
  const TrackerScreen({super.key, required this.program});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final UserService _userService = UserService();
  final AuthService _auth = AuthService();
  
  late List<LoggedExercise> _exercises;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize log with program defaults
    _exercises = widget.program.exercices.map((ex) {
      return LoggedExercise(
        name: ex['nom'] ?? 'Unnamed',
        weight: 0.0,
        reps: ex['reps'] as int? ?? 0,
        sets: ex['séries'] as int? ?? 0,
      );
    }).toList();
  }

  Future<void> _finishWorkout() async {
    setState(() => _isSaving = true);
    try {
      final log = WorkoutLog(
        id: '', // Backend generates
        userId: _auth.username ?? 'guest', // Using username as ID for prototype simplicity
        programId: widget.program.id,
        programTitle: widget.program.titre,
        date: DateTime.now(),
        exercises: _exercises,
      );

      await _userService.saveLog(log);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Workout Saved! Great job!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Track: ${widget.program.titre}")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          final ex = _exercises[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(ex.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   const SizedBox(height: 10),
                   Row(
                     children: [
                       Expanded(
                         child: TextFormField(
                           initialValue: ex.weight.toString(),
                           keyboardType: TextInputType.number,
                           decoration: const InputDecoration(labelText: "Weight (kg)"),
                           onChanged: (val) {
                             // Create new object to update state (immutable style safer)
                             _exercises[index] = LoggedExercise(
                               name: ex.name,
                               weight: double.tryParse(val) ?? ex.weight,
                               reps: ex.reps,
                               sets: ex.sets,
                             );
                           },
                         ),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: TextFormField(
                           initialValue: ex.reps.toString(),
                           keyboardType: TextInputType.number,
                           decoration: const InputDecoration(labelText: "Reps"),
                            onChanged: (val) {
                             _exercises[index] = LoggedExercise(
                               name: ex.name,
                               weight: ex.weight,
                               reps: int.tryParse(val) ?? ex.reps,
                               sets: ex.sets,
                             );
                           },
                         ),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: TextFormField(
                           initialValue: ex.sets.toString(),
                           keyboardType: TextInputType.number,
                           decoration: const InputDecoration(labelText: "Sets"),
                            onChanged: (val) {
                             _exercises[index] = LoggedExercise(
                               name: ex.name,
                               weight: ex.weight,
                               reps: ex.reps,
                               sets: int.tryParse(val) ?? ex.sets,
                             );
                           },
                         ),
                       ),
                     ],
                   )
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _finishWorkout,
           style: ElevatedButton.styleFrom(
             padding: const EdgeInsets.all(16),
             backgroundColor: Colors.green,
           ),
          child: _isSaving 
             ? const CircularProgressIndicator(color: Colors.white) 
             : const Text("FINISH WORKOUT", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
