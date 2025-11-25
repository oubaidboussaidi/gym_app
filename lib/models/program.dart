class Program {
  final String id;
  final String title;
  final String description;

  Program({required this.id, required this.title, required this.description});

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
    };
  }
}
