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

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['_id'] ?? json['id'],
      userId: json['userId'] ?? '',
      assignmentId: json['assignmentId'],
      weekNumber: json['weekNumber'],
      dayNumber: json['dayNumber'],
      durationMinutes: json['durationMinutes'] ?? 0,
      logs: (json['logs'] as List<dynamic>?)
          ?.map((e) => ExerciseLog.fromJson(e))
          .toList() ?? [],
      userFeedback: json['userFeedback'],
      userRPE: json['userRPE'],
    );
  }

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

  factory ExerciseLog.fromJson(Map<String, dynamic> json) {
    return ExerciseLog(
      exerciseId: json['exerciseId'] ?? '',
      name: json['name'] ?? 'Unknown Exercise',
      sets: (json['sets'] as List<dynamic>?)
          ?.map((e) => SetLog.fromJson(e))
          .toList() ?? [],
    );
  }

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

  factory SetLog.fromJson(Map<String, dynamic> json) {
    return SetLog(
      setNumber: json['setNumber'] ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      reps: json['reps'] ?? 0,
      rpe: json['rpe'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'weight': weight,
      'reps': reps,
      'rpe': rpe,
    };
  }
}
