class UserModel {
  final int id;
  final String email;
  final String name;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory UserModel.fromMap(Map map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      role: map['role'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
    };
  }
}
