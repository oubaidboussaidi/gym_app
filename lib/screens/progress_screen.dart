import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gym_app/models/workout_session.dart';
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
  
  List<WorkoutSession> _logs = []; // Updated type
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    try {
      final userId = _auth.userId; 
      if (userId != null) {
        final logs = await _userService.getLogs(userId);
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
    List<FlSpot> spots = [];
    for (int i = 0; i < _logs.length && i < 7; i++) {
        // Plot duration or number of exercises
        spots.add(FlSpot(i.toDouble(), _logs[i].logs.length.toDouble())); 
    }
    
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
                  // WorkoutSession doesn't store programTitle directly, use ID or "Workout"
                  title: const Text("Workout Session", style: TextStyle(fontWeight: FontWeight.bold)),
                  // WorkoutSession doesn't store timestamp directly in Model if not added, assume now or add date field.
                  // Backend adds timestamps. Update Model to include createdAt if needed. 
                  // For now, just show abstract info.
                  subtitle: Text("Duration: ${log.durationMinutes} min"),
                  trailing: Text("${log.logs.length} Exercises", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                  onTap: () {
                    showDialog(context: context, builder: (_) => AlertDialog(
                      title: const Text("Details"),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView(
                          shrinkWrap: true,
                          children: log.logs.map((e) => ListTile(
                            title: Text(e.name),
                            subtitle: Text("${e.sets.length} Sets"),
                          )).toList(),
                        ),
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
