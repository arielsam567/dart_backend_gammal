class GiftModel {
  final int id;
  final int userId;
  final String name;
  final String? description;
  final int? price;

  GiftModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.price,
  });

  factory GiftModel.fromMap(Map map) {
    return GiftModel(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
      description: map['description'],
      price: map['price'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'description': description,
      'price': price,
    };
  }
}
