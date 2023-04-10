import 'dart:convert';

import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthGuard extends ModularMiddleware {
  final List<String> roles;
  final bool isRefreshToken;

  AuthGuard({
    this.roles = const [],
    this.isRefreshToken = false,
  });

  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    final extractor = Modular.get<RequestExtractor>();
    final jwt = Modular.get<JwtService>();

    return (request) {
      if (!request.headers.containsKey('authorization')) {
        return Response.forbidden(jsonEncode({'message': 'Token not found'}));
      }
      final token = extractor.getAuthBearerToken(request);
      try {
        jwt.verifyToken(token, isRefreshToken ? 'refreshToken' : 'accessToken');
        final payload = jwt.getPayload(token);

        if (roles.isNotEmpty && !roles.contains(payload['role'])) {
          return Response.forbidden(jsonEncode({'message': 'User not authorized'}));
        }

        return handler(request);
      } catch (e) {
        return Response.forbidden(jsonEncode({'message': 'Token is invalid | $e'}));
      }
    };
  }
}
