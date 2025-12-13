class WorkoutLog {
  final String id;
  final String userId;
  final String programId;
  final String programTitle;
  final DateTime date;
  final List<LoggedExercise> exercises;

  WorkoutLog({
    required this.id,
    required this.userId,
    required this.programId,
    required this.programTitle,
    required this.date,
    required this.exercises,
  });

  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      programId: json['programId'] ?? '',
      programTitle: json['programTitle'] ?? 'Unknown Program',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => LoggedExercise.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'programId': programId,
      'programTitle': programTitle,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}

class LoggedExercise {
  final String name;
  final double weight;
  final int reps;
  final int sets;

  LoggedExercise({
    required this.name,
    required this.weight,
    required this.reps,
    required this.sets,
  });

  factory LoggedExercise.fromJson(Map<String, dynamic> json) {
    return LoggedExercise(
      name: json['name'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      reps: json['reps'] ?? 0,
      sets: json['sets'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'reps': reps,
      'sets': sets,
    };
  }
}
