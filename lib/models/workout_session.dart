class WorkoutSession {
  final String? id;
  final String userId;
  final String? assignmentId;
  final int? weekNumber;
  final int? dayNumber;
  final int durationMinutes;
  final List<ExerciseLog> logs;
  final String? userFeedback;
  final int? userRPE;

  WorkoutSession({
    this.id,
    required this.userId,
    this.assignmentId,
    this.weekNumber,
    this.dayNumber,
    required this.durationMinutes,
    required this.logs,
    this.userFeedback,
    this.userRPE,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'assignmentId': assignmentId,
      'weekNumber': weekNumber,
      'dayNumber': dayNumber,
      'durationMinutes': durationMinutes,
      'logs': logs.map((e) => e.toJson()).toList(),
      'userFeedback': userFeedback,
      'userRPE': userRPE,
    };
  }
}

class ExerciseLog {
  final String exerciseId;
  final String name;
  final List<SetLog> sets;

  ExerciseLog({
    required this.exerciseId,
    required this.name,
    required this.sets,
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'name': name,
      'sets': sets.map((e) => e.toJson()).toList(),
    };
  }
}

class SetLog {
  final int setNumber;
  final double weight;
  final int reps;
  final int rpe;

  SetLog({
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.rpe,
  });

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'weight': weight,
      'reps': reps,
      'rpe': rpe,
    };
  }
}
