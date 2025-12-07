class Program {
  final String id;
  final String titre;
  final String niveau;
  final Map<String, dynamic> coach;
  final List<Map<String, dynamic>> exercices;

  Program({
    required this.id,
    required this.titre,
    required this.niveau,
    required this.coach,
    required this.exercices,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['_id'] ?? json['id'] ?? '',
      titre: json['titre'] ?? '',
      niveau: json['niveau'] ?? '',
      coach: json['coach'] ?? {},
      exercices: (json['exercices'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'titre': titre,
      'niveau': niveau,
      'coach': coach,
      'exercices': exercices,
    };
  }
}
