import 'package:backend/src/feature/user/models/user_model.dart';

class GiftModel {
  final int id;
  final int userId;
  final String name;
  final String? description;
  final int? price;
  final UserModel? user;

  GiftModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.price,
    this.user,
  });

  factory GiftModel.fromMap(Map map) {
    return GiftModel(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
      description: map['description'],
      price: map['price'],
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
    );
  }

  Map toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'description': description,
      'price': price,
      if (user != null) 'user': user!.toMap(),
    };
  }
}
