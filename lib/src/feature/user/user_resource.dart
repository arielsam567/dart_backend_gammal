import 'dart:async';

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

  FutureOr<Response> _getAllUsers(Request request) async {
    return Response.ok('GET ALL USER');
  }

  FutureOr<Response> _getUserById(ModularArguments arguments) async {
    return Response.ok('GET USER BY ID ${arguments.params}');
  }

  FutureOr<Response> _updateUser(ModularArguments arguments) async {
    return Response.ok('UPDATE USER');
  }

  FutureOr<Response> _addUser(ModularArguments arguments) async {
    return Response.ok('ADD USER');
  }

  FutureOr<Response> _deleteUser(ModularArguments arguments) async {
    return Response.ok('DELETE USER BY ID ${arguments.params}');
  }
}
