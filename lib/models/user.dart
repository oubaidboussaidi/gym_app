class User {
  final String id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final Map<String, dynamic> profile;

  // Legacy/Optional fields
  final Map<String, dynamic> abonnement;
  final Map<String, dynamic> progression;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.firstName = '',
    this.lastName = '',
    this.profile = const {},
    this.abonnement = const {},
    this.progression = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    
    // Handle nested profile from backend
    final profileData = json['profile'] as Map<String, dynamic>? ?? {};
    
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      firstName: profileData['firstName'] ?? '',
      lastName: profileData['lastName'] ?? '',
      profile: profileData,
      abonnement: json['abonnement'] ?? {},
      progression: json['progression'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'profile': profile,
      'abonnement': abonnement, // Keep for now
      'progression': progression,
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isCoach => role == 'coach';
}
