class Exercise {
  final String id;
  final String name;
  final String category;
  final String description;
  final String equipment;
  final String? videoUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.equipment,
    this.videoUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'other',
      description: json['description'] ?? '',
      equipment: json['equipment'] ?? 'none',
      videoUrl: json['videoUrl'],
    );
  }
}
