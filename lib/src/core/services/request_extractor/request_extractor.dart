import 'dart:convert';

import 'package:shelf/shelf.dart';

class RequestExtractor {
  String getAuthBearerToken(Request request) {
    print('headers: ${request.headers}');
    var token = request.headers['authorization'] ?? '';
    token = token.split(' ').last;
    return token;
  }

  LoginCredetial getAuthBasicToken(Request request) {
    var token = request.headers['authorization'] ?? '';
    print('token: $token');
    token = token.split(' ').last;
    token = String.fromCharCodes(base64Decode(token));
    var credentials = token.split(':');
    return LoginCredetial(
      email: credentials[0],
      password: credentials[1],
    );
  }
}

class LoginCredetial {
  final String email;
  final String password;

  LoginCredetial({required this.email, required this.password});
}
