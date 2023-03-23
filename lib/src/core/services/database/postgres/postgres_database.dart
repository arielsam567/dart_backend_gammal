import 'dart:async';

import 'package:backend/src/core/services/database/remove_database.dart';
import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_modular/shelf_modular.dart';

class PostgressDatabase implements RemoteDatabase, Disposable {
  final completer = Completer<PostgreSQLConnection>();
  final DotEnvService dotEnv;

  PostgressDatabase(this.dotEnv) {
    _init();
  }

  Future<void> _init() async {
    final String url = dotEnv.get('DATABASE_URL')!;
    final Uri uri = Uri.parse(url);
    var connection = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments[0],
      username: uri.userInfo.split(':')[0],
      password: uri.userInfo.split(':')[1],
    );
    await connection.open();
    completer.complete(connection);
  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String query, {
    Map<String, dynamic> variables = const {},
  }) async {
    final connection = await completer.future;
    final result = await connection.mappedResultsQuery(query,
        substitutionValues: variables);
    return result;
  }

  @override
  void dispose() async {
    final connection = await completer.future;
    await connection.close();
  }
}
