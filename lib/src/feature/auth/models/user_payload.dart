class UserPayload {
  final String id;
  final String role;

  UserPayload({
    required this.id,
    required this.role,
  });

  factory UserPayload.fromJson(Map<String, dynamic> json) {
    return UserPayload(
      id: json['id'],
      role: json['role'],
    );
  }
}
