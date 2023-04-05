import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        //login
        Route.get('/auth/login', _login),
        //register
        //refresh token
        //logout
        //check token
        //update password
      ];

  FutureOr<Response> _login() {
    return Response.ok('login');
  }
}
