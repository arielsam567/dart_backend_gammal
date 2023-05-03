import 'package:backend/src/core/services/database/remove_database.dart';

class GiftDatasource {
  final RemoteDatabase database;
  final String table = 'Gift';

  GiftDatasource(this.database);

  Future<Map> createGift({required int userId, required Map<String, dynamic> map}) async {
    final List<String> columns = map.keys.where((key) => key != 'id' || key != 'userId').toList();

    String valuesFields = '';
    for (int i = 0; i < columns.length; i++) {
      valuesFields += '@${columns[i]}';
      if (i != columns.length - 1) {
        valuesFields += ', ';
      }
    }

    map['userId'] = userId;

    final String query = 'INSERT INTO "$table" ("userId", ${columns.join(',')}) VALUES ( @userId, $valuesFields ) RETURNING *;';

    final List result = await database.query(
      query,
      variables: map,
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

  Future<Map<String, dynamic>> getGiftByIdWithUserDetails(String id) async {
    try {
      final List<Map<String, dynamic>> result = await database.query(
        'SELECT * FROM "$table" JOIN "User" ON "$table"."userId" = "User"."id" WHERE "$table"."id" = @id;',
        variables: {
          'id': id,
        },
      );

      if (result.isEmpty) {
        return {};
      }

      final Map<String, dynamic> giftData = result[0]['Gift'];
      final Map<String, dynamic> userData = result[0]['User'];
      final Map<String, dynamic> combinedData = Map<String, dynamic>.from(giftData);
      userData.remove('password');
      combinedData['user'] = userData;

      return combinedData;
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
