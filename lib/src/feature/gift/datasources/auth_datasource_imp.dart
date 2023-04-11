import 'package:backend/src/core/services/database/remove_database.dart';

class GiftDatasourceImpl {
  final RemoteDatabase database;
  final String table = 'Gift';

  GiftDatasourceImpl(this.database);

  Future<Map> createGift({required String userId, required Map map}) async {
    print('NAME: ${map['name']}');
    final result = await database.query(
      'INSERT INTO "$table" (name) VALUES ( @name ) RETURNING id, name;',
      variables: {
        'name': map['name'],
      },
    );
    print('result ${result.first}');

    return result.map((element) => element[table]).first!;
  }
}
