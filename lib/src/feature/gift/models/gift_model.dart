class GiftModel {
  final int id;
  final String name;

  GiftModel({
    required this.id,
    required this.name,
  });

  factory GiftModel.fromMap(Map map) {
    print('fuck $map');
    return GiftModel(
      id: map['id'],
      name: map['name'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
