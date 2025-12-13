import 'package:gym_app/models/program.dart';

class ProgramAssignment {
  final String id;
  final String userId;
  final String programId;
  final String status;
  final Program? program; // Populated program details

  ProgramAssignment({
    required this.id,
    required this.userId,
    required this.programId,
    required this.status,
    this.program,
  });

  factory ProgramAssignment.fromJson(Map<String, dynamic> json) {
    Program? prog;
    if (json['programId'] is Map) {
      prog = Program.fromJson(json['programId']);
    }

    return ProgramAssignment(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      programId: json['programId'] is String ? json['programId'] : (json['programId']['_id'] ?? ''),
      status: json['status'] ?? 'active',
      program: prog,
    );
  }
}
