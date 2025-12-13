import 'package:flutter/material.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/models/workout_log.dart';
import 'package:gym_app/services/user_service.dart';

class AthleteProgressScreen extends StatefulWidget {
  final User athlete;

  const AthleteProgressScreen({super.key, required this.athlete});

  @override
  State<AthleteProgressScreen> createState() => _AthleteProgressScreenState();
}

class _AthleteProgressScreenState extends State<AthleteProgressScreen> {
  final UserService _userService = UserService();
  List<WorkoutLog> _logs = [];
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
                  final log = _logs[index];
                  // Basic rendering of a log session
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ExpansionTile(
                      title: Text("Workout - ${log.date.toLocal().toString().split(' ')[0]}"),
                      subtitle: Text("Duration: ${log.durationMinutes} min | RPE: ${log.userRpe}"),
                      children: log.exercises.map((ex) {
                        return ListTile(
                          title: Text(ex.exerciseName.isNotEmpty ? ex.exerciseName : "Exercise"),
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
