import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/database/remove_database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/user', _getAllUsers),
        Route.get('/user/:id', _getUserById),
        Route.post('/user', _addUser),
        Route.put('/user', _updateUser),
        Route.delete('/user/:id', _deleteUser),
      ];

  FutureOr<Response> _getAllUsers(Injector injector) async {
    final database = injector.get<RemoteDatabase>();
    final result = await database.query('SELECT * FROM "User" ORDER BY ID;');
    final List users = result.map((e) => e['User']).toList();
    return Response.ok(jsonEncode(users));
  }

  FutureOr<Response> _getUserById(ModularArguments arguments, Injector injector) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'SELECT * FROM "User" where id = @id;',
      variables: {'id': id},
    );
    final userMap = result.map((e) => e['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _updateUser(ModularArguments arguments, Injector injector) async {
    final Map<String, dynamic> userParams = arguments.data as Map<String, dynamic>;

    final List columns = userParams.keys.where((key) => key != 'id' || key != 'email' || key != 'password').map((key) => '$key=@$key').toList();
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'UPDATE "User" SET ${columns.join(',')} WHERE id=@id RETURNING id, email, name, role',
      variables: userParams,
    );
    final userMap = result.map((e) => e['User']).first;
    return Response(201, body: jsonEncode(userMap));
  }

  FutureOr<Response> _addUser(ModularArguments arguments, Injector injector) async {
    final Map<String, dynamic> userParams = arguments.data as Map<String, dynamic>;
    userParams.remove('id');
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'INSERT INTO "User" (email, password, name) VALUES ( @email, @password, @name ) RETURNING id, email, name, role',
      variables: userParams,
    );
    final userMap = result.map((e) => e['User']).first;
    return Response(201, body: jsonEncode(userMap));
  }

  FutureOr<Response> _deleteUser(ModularArguments arguments, Injector injector) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    await database.query('DELETE FROM "User" where id = @id;', variables: {'id': id});
    return Response.ok('DELETE USER BY ID ${arguments.params}');
  }
}
