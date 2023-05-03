import 'package:backend/src/core/services/database/remove_database.dart';

class GiftDatasource {
  final RemoteDatabase database;
  final String table = 'Gift';

  GiftDatasource(this.database);

  Future<Map> createGift({required int userId, required Map map}) async {
    final List result = await database.query(
      'INSERT INTO "$table" (name, "userId") VALUES ( @name, @userId ) RETURNING id, name;',
      variables: {
        'name': map['name'],
        'userId': userId,
      },
    );

    return result.map((element) => element[table]).first!;
  }

  Future<Map> getAllGifts(int limit, int offset) async {
    final List result = await database.query(
      'SELECT * FROM "$table" LIMIT @limit OFFSET @offset;',
      variables: {
        'limit': limit,
        'offset': offset,
      },
    );
    final Map map = result.asMap();
    return map;
  }

  Future<Map> getGiftById(String id) async {
    try {
      final List result = await database.query(
        'SELECT * FROM "$table" WHERE id = @id;',
        variables: {
          'id': id,
        },
      );
      final Map map = result.map((element) => element[table]).first!;
      return map;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map> getGiftByUserId(int userId) async {
    final List result = await database.query(
      'SELECT * FROM "$table" WHERE "userId" = @userId;',
      variables: {
        'userId': userId,
      },
    );
    final Map map = result.asMap();
    return map;
  }
}
