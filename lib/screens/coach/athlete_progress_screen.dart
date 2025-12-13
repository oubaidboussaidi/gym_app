import 'package:flutter/material.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/models/workout_session.dart';
import 'package:gym_app/services/user_service.dart';

class AthleteProgressScreen extends StatefulWidget {
  final User athlete;

  const AthleteProgressScreen({super.key, required this.athlete});

  @override
  State<AthleteProgressScreen> createState() => _AthleteProgressScreenState();
}

class _AthleteProgressScreenState extends State<AthleteProgressScreen> {
  final UserService _userService = UserService();
  List<WorkoutSession> _logs = []; // Updated Type
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      final logs = await _userService.getLogs(widget.athlete.id);
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error (empty logs for now)
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.athlete.firstName}'s Progress")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _logs.isEmpty
            ? const Center(child: Text("No workouts logged yet."))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index]; // log is WorkoutSession
                  // Basic rendering of a log session
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ExpansionTile(
                      // Workaround: Mock date if ID based or use timestamp if backend sends it. 
                      // Backend schema has timestamps: true, sends createdAt. 
                      // For now just show "Workout"
                      title: Text("Workout (Time: ${log.durationMinutes} min)"),
                      subtitle: Text("RPE: ${log.userRPE ?? '-'}"),
                      children: log.logs.map((ex) { // ex is ExerciseLog
                        return ListTile(
                          title: Text(ex.name),
                          subtitle: Text("${ex.sets.length} Sets completed"),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
    );
  }
}
