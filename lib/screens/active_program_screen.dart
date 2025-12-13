import 'package:flutter/material.dart';
import 'package:gym_app/models/program_assignment.dart';
import 'package:gym_app/screens/tracker_screen.dart';

class ActiveProgramScreen extends StatelessWidget {
  final ProgramAssignment assignment;

  const ActiveProgramScreen({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    // Determine the user's current progress (hacky for now, default to W1D1 if not stored)
    // In a real app we'd store "currentWeek" and "currentDay" in the Assignment log.
    
    final structure = assignment.program?.structure ?? {};
    final weeks = (structure['weeks'] as List<dynamic>?) ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(assignment.program?.title ?? "My Program"),
      ),
      body: weeks.isEmpty
          ? const Center(child: Text("No detailed structure available."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: weeks.length,
              itemBuilder: (context, index) {
                final week = weeks[index];
                final days = (week['days'] as List<dynamic>?) ?? [];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text("Week ${week['weekNumber']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    initiallyExpanded: index == 0, // Expand first week
                    children: days.map<Widget>((day) {
                      return ListTile(
                        leading: const Icon(Icons.fitness_center),
                        title: Text(day['name']),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to Day View / Workout Tracker
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TrackerScreen(
                            dayStructure: day,
                            assignmentId: assignment.id,
                            weekNumber: week['weekNumber'],
                            dayNumber: index + 1, // Hacky day number derivation? Or store day index?
                            // Actually day structure doesn't store day number explicitly usually, but `days` list index implies it.
                            // Let's passed index+1 as day num
                          )));
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
