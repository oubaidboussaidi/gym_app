import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gym_app/models/workout_log.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/services/user_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final UserService _userService = UserService();
  final AuthService _auth = AuthService();
  
  List<WorkoutLog> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    try {
      final username = _auth.username;
      if (username != null) {
        // Prototype hack: Using username as ID. In real app use ID.
        final logs = await _userService.getLogs(username);
        if (mounted) setState(() { _logs = logs; _isLoading = false; });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint("Error fetching logs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate dummy spots if no logs, or real spots from logs (e.g. volume or count)
    // For prototype, let's just plot number of exercises per workout as a "score"
    List<FlSpot> spots = [];
    for (int i = 0; i < _logs.length && i < 7; i++) {
        // Reverse order for chart (oldest left)? Actually list is desc.
        // Let's take last 7 logs.
        spots.add(FlSpot(i.toDouble(), _logs[i].exercises.length.toDouble())); // simple metric
    }
    
    // If empty, show dummy line
    if (spots.isEmpty) {
        spots = [const FlSpot(0, 2), const FlSpot(1, 3), const FlSpot(2, 4), const FlSpot(3, 3)];
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Stats & History", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Activity (Exercises per Session)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.deepPurple,
                        barWidth: 4,
                        belowBarData: BarAreaData(show: true, color: Colors.deepPurple.withOpacity(0.2)),
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              if (_logs.isEmpty)
                 const Center(child: Text("No workout history yet.", style: TextStyle(color: Colors.grey))),

              ..._logs.map((log) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.green),
                  ),
                  title: Text(log.programTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat.yMMMd().add_jm().format(log.date)),
                  trailing: Text("${log.exercises.length} Exercises", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                  onTap: () {
                    // Show details dialog
                    showDialog(context: context, builder: (_) => AlertDialog(
                      title: Text(log.programTitle),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: log.exercises.map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.name),
                            Text("${e.weight}kg x ${e.reps}"),
                          ],
                        )).toList(),
                      ),
                    ));
                  },
                ),
              )),
            ],
          ),
      ),
    );
  }
}
