class User {
  final String id;
  final String username;
  final String email;
  final int? age;
  final Map<String, dynamic> abonnement;
  final Map<String, dynamic> progression;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.age,
    this.abonnement = const {},
    this.progression = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      age: json['age'],
      abonnement: json['abonnement'] ?? {},
      progression: json['progression'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'age': age,
      'abonnement': abonnement,
      'progression': progression,
    };
  }
}
