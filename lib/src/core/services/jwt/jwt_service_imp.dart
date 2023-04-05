import 'package:backend/src/core/services/dot_env/dot_env_service.dart';

import 'jwt_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtServiceImp implements JwtService {
  final DotEnvService _dotEnvService;
  late String key;

  JwtServiceImp(this._dotEnvService) {
    key = _dotEnvService.get('JWT_SECRET')!;
  }

  @override
  String generateToken(Map claims, String audience) {
    final jwt = JWT(claims, audience: Audience.one(audience));

    final token = jwt.sign(SecretKey(key));
    print('Signed token: $token\n');
    return token;
  }

  @override
  Map getPayload(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(key),
      checkExpiresIn: false,
      checkHeaderType: false,
      checkNotBefore: false,
    );
    return jwt.payload;
  }

  @override
  void verifyToken(String token, String audience) {
    JWT.verify(token, SecretKey(key), audience: Audience.one(audience));
  }
}
