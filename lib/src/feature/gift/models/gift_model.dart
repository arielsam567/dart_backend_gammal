import 'package:backend/src/feature/user/models/user_model.dart';

class GiftModel {
  final int id;
  final int userId;
  final String name;
  final String? description;
  final int? price;
  final UserModel? user;
  final String? image;

  GiftModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.price,
    this.user,
    this.image,
  });

  factory GiftModel.fromMap(Map map) {
    return GiftModel(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
      description: map['description'],
      price: map['price'],
      image: map['image'],
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
      'image': image,
      if (user != null) 'user': user!.toMap(),
    };
  }
}
