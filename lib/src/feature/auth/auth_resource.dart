import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/services/database/remove_database.dart';
import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        //login
        Route.post('/auth/login', _login),
      ];

  FutureOr<Response> _login(Request request, Injector injector) async {
    print('INICIO');

    final extractor = injector.get<RequestExtractor>();
    final bcrypt = injector.get<BcryptService>();
    final database = injector.get<RemoteDatabase>();
    final jwt = injector.get<JwtService>();

    final credential = extractor.getAuthBasicToken(request);
    final email = credential.email;
    print('email: $email');

    //TENTA PEGAR NA BASE DE DADOS O USUARIO COM O EMAIL PASSADO
    final result = await database.query(
      'SELECT role, id, password FROM "User" where email = @email;',
      variables: {'email': email},
    );

    print('222');
    //SE NAO EXISTIR USUARIO COM O EMAIL PASSADO
    if (result.isEmpty) {
      return Response.forbidden(jsonEncode('Email or password is incorrect'));
    }
    print('333');
    final user = result.map((e) => e['User']).first;

    print('444');
    //SE A SENHA PASSADA NAO FOR IGUAL A SENHA DO USUARIO
    if (!bcrypt.checkHash(credential.password, user!['password'])) {
      return Response.forbidden(jsonEncode('Password is incorrect'));
    }

    //SE A SENHA PASSADA FOR IGUAL A SENHA DO USUARIO
    final payload = user..remove('password');
    payload['exp'] = _expirationTime(1);
    final token = jwt.generateToken(payload, 'accessToken');

    payload['exp'] = _expirationTime(24 * 3);
    final refreshToken = jwt.generateToken(payload, 'refreshToken');

    return Response.ok(
      jsonEncode(
        {
          'token': token,
          'refreshToken': refreshToken,
        },
      ),
    );
  }

  int _expirationTime(int horas) {
    final now = DateTime.now().add(Duration(hours: horas));
    return now.millisecondsSinceEpoch * 1000;
  }
}
