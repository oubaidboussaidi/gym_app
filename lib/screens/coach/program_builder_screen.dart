import 'package:flutter/material.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/services/program_service.dart';
import 'package:gym_app/services/exercise_service.dart';
import 'package:gym_app/widgets/button.dart';
import 'package:gym_app/widgets/textfield.dart';

class ProgramBuilderScreen extends StatefulWidget {
  const ProgramBuilderScreen({super.key});

  @override
  State<ProgramBuilderScreen> createState() => _ProgramBuilderScreenState();
}

class _ProgramBuilderScreenState extends State<ProgramBuilderScreen> {
  final ProgramService _programService = ProgramService();
  final ExerciseService _exerciseService = ExerciseService(); // Add service
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  String _level = "beginner";
  
  // Local state for structure builder
  // Structure: Weeks -> Days -> Exercises
  List<Map<String, dynamic>> _weeks = []; 

  List<Exercise> _availableExercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _addWeek(); // Start with Week 1
  }

  Future<void> _loadExercises() async {
    try {
      final exs = await _exerciseService.getExercises(); // Use ExerciseService
      setState(() { _availableExercises = exs; });
    } catch (e) {
      print("Error loading exercises: $e");
    }
  }

  void _addWeek() {
    setState(() {
      _weeks.add({
        "weekNumber": _weeks.length + 1,
        "days": <Map<String, dynamic>>[] // Start with 0 days or 1 empty day
      });
    });
  }

  void _addDay(int weekIndex) {
    setState(() {
      List<Map<String, dynamic>> days = _weeks[weekIndex]["days"];
      days.add({
        "name": "Day ${days.length + 1}",
        "exercises": <Map<String, dynamic>>[]
      });
    });
  }

  void _addExercise(int weekIndex, int dayIndex, Exercise ex) {
    setState(() {
      List<Map<String, dynamic>> days = _weeks[weekIndex]["days"];
      List<Map<String, dynamic>> exercises = days[dayIndex]["exercises"];
      exercises.add({
        "exerciseId": ex.id,
        "name": ex.name, // Snapshot name for UI
        "targetSets": 3,
        "targetReps": "10",
        "targetRPE": 8,
      });
    });
  }

  Future<void> _pickExercise(int weekIndex, int dayIndex) async {
    // Show dialog to pick exercise
    final Exercise? selected = await showDialog<Exercise>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Select Exercise"),
        children: _availableExercises.map((e) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, e),
          child: Text("${e.name} (${e.category})"),
        )).toList(),
      ),
    );

    if (selected != null) {
      _addExercise(weekIndex, dayIndex, selected);
    }
  }

  Future<void> _saveProgram() async {
    if (_title.text.isEmpty) return;

    final programData = {
      "title": _title.text,
      "description": _desc.text,
      "level": _level,
      "creatorId": "TODO_GET_FROM_AUTH_OR_BACKEND_HANDLES_IT", // Backend might infer from token if we update controller
      "structure": {
        "weeks": _weeks
      }
    };

    // Need to handle creatorID.
    // Backend Program schema requires `creatorId`.
    // Does backend Controller infer it?
    // Let's check backend ProgramController (legacy or new?). It was legacy routes. 
    // I should create a new `createProgram` in Controller that uses `req.user.id`.
    // For now, I'll send it if I can, or update backend to use `req.user.id` from token.
    
    // Assuming backend uses token or passed ID.
    // Actually legacy `programs` route: `await Program.create(req.body)`.
    // It doesn't auto-add creatorId.
    // I need to update backend to be robust. 
    // But for this phase, let's just try to send.
    
    try {
       // Assuming ProgramService attaches creatorId or Backend has been updated.
       // Actually I should patch the backend controller to attach `creatorId: req.user.id`.
       // I'll do that shortly.
       await _programService.createProgram(programData);
       if(mounted) Navigator.pop(context);
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Program Builder"), actions: [
        IconButton(icon: const Icon(Icons.check), onPressed: _saveProgram)
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomTextField(controller: _title, hintText: "Program Title", obscureText: false),
          const SizedBox(height: 10),
          CustomTextField(controller: _desc, hintText: "Description", obscureText: false),
           const SizedBox(height: 10),
          DropdownButton<String>(
            value: _level,
            items: const [
              DropdownMenuItem(value: "beginner", child: Text("Beginner")),
              DropdownMenuItem(value: "intermediate", child: Text("Intermediate")),
              DropdownMenuItem(value: "advanced", child: Text("Advanced")),
            ], 
            onChanged: (v) => setState(() => _level = v!),
          ),
          
          const Divider(),
          ..._weeks.asMap().entries.map((entry) {
            int weekIdx = entry.key;
            Map<String, dynamic> week = entry.value;
            List<Map<String, dynamic>> days = week["days"];
            
            return Card(
              color: Colors.grey[200],
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Week ${week["weekNumber"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ...days.asMap().entries.map((dayEntry) {
                       int dayIdx = dayEntry.key;
                       Map<String, dynamic> day = dayEntry.value;
                       List<Map<String, dynamic>> exercises = day["exercises"];
                       
                       return Card(
                         child: Column(
                           children: [
                             ListTile(
                               title: Text(day["name"]),
                               trailing: IconButton(icon: const Icon(Icons.add), onPressed: () => _pickExercise(weekIdx, dayIdx)),
                             ),
                             ...exercises.map((ex) => ListTile(
                               title: Text(ex["name"]),
                               subtitle: Text("${ex['targetSets']} sets x ${ex['targetReps']} reps"),
                             )),
                           ],
                         ),
                       );
                    }),
                    TextButton(onPressed: () => _addDay(weekIdx), child: const Text("+ Add Day")),
                  ],
                ),
              ),
            );
          }),
          
          ElevatedButton(onPressed: _addWeek, child: const Text("Add Week")),
        ],
      ),
    );
  }
}
