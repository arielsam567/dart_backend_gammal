import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/services/database/remove_database.dart';
import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend/src/feature/auth/guard/auth_guard.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/auth/login', _login),
        Route.get(
          '/auth/refresh_token',
          _refreshToken,
          middlewares: [AuthGuard(isRefreshToken: true)],
        ),
        Route.get('/auth/check_token', _chechToken, middlewares: [AuthGuard()])
      ];

  FutureOr<Response> _login(Request request, Injector injector) async {
    final extractor = injector.get<RequestExtractor>();
    final bcrypt = injector.get<BcryptService>();
    final database = injector.get<RemoteDatabase>();
    final jwt = injector.get<JwtService>();

    final credential = extractor.getAuthBasicToken(request);
    final email = credential.email;

    //TENTA PEGAR NA BASE DE DADOS O USUARIO COM O EMAIL PASSADO
    final result = await database.query(
      'SELECT role, id, password FROM "User" where email = @email;',
      variables: {'email': email},
    );

    //SE NAO EXISTIR USUARIO COM O EMAIL PASSADO
    if (result.isEmpty) {
      return Response.forbidden(jsonEncode('Email or password is incorrect'));
    }
    final Map? user = result.map((e) => e['User']).first;

    //SE A SENHA PASSADA NAO FOR IGUAL A SENHA DO USUARIO
    if (!bcrypt.checkHash(credential.password, user!['password'])) {
      return Response.forbidden(jsonEncode('Password is incorrect'));
    }
    final payload = user..remove('password');

    return Response.ok(generateToken(payload, jwt));
  }

  FutureOr<Response> _chechToken(Request request, Injector injector) {
    return Response.ok(jsonEncode('OK'));
  }

  FutureOr<Response> _refreshToken(Request request, Injector injector) async {
    final extractor = injector.get<RequestExtractor>();
    final jwt = injector.get<JwtService>();
    final database = injector.get<RemoteDatabase>();

    final String token = extractor.getAuthBearerToken(request);
    Map payload = jwt.getPayload(token);
    final String id = payload['id'].toString();

    //TENTA PEGAR NA BASE DE DADOS O USUARIO COM O EMAIL PASSADO
    final result = await database.query(
      'SELECT role, id, password FROM "User" where id = @id;',
      variables: {'id': id},
    );

    payload = result.map((e) => e['User']).first!..remove('password');

    return Response.ok(jsonEncode(generateToken(payload, jwt)));
  }

  Map generateToken(Map payload, JwtService jwt) {
    payload['exp'] = _expirationTime(Duration(hours: 1));
    final token = jwt.generateToken(payload, 'accessToken');

    payload['exp'] = _expirationTime(Duration(days: 1));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');

    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }

  int _expirationTime(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    final expiresIn = Duration(milliseconds: expiresDate.millisecondsSinceEpoch);
    return expiresIn.inSeconds;
  }
}
