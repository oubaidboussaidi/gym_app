class Program {
  final String id;
  final String title;
  final String description;
  final String level;
  final Map<String, dynamic> structure; // Nested structure

  Program({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    this.structure = const {},
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      level: json['level'] ?? 'beginner',
      structure: json['structure'] ?? {},
    );
  }
}
