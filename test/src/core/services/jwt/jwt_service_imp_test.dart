import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend/src/core/services/jwt/jwt_service_imp.dart';
import 'package:test/test.dart';

void main() {
  String token = '';
  final DotEnvService dotEnvService = DotEnvService(mocks: {"JWT_SECRET": "123"});
  final JwtServiceImp jwtServiceImp = JwtServiceImp(dotEnvService);
  final String audience = "accessToken";

  test('jwt create', () {
    final DateTime expireDate = DateTime.now().add(Duration(seconds: 30));
    final int expiresIn = Duration(milliseconds: expireDate.millisecondsSinceEpoch).inSeconds;
    token = jwtServiceImp.generateToken(
      {
        "id": 1,
        "exp": expiresIn,
      },
      audience,
    );

    print('TOKEN $token');
  });

  test('jwt verify', () {
    jwtServiceImp.verifyToken(token, audience);
    expect(1, 1);
  });

  test('jwt get payload', () {
    final Map payloadAux = jwtServiceImp.getPayload(token);
    expect(payloadAux['id'], 1);
  });
}
