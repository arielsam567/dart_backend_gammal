import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:test/test.dart';

void main() {
  test('dot env service ...', () async {
    final env = DotEnvService.instance;
    expect(env.get('DATABASE_URL'),
        'postgres://postgres:12345678@localhost:5432/postgres');
  });
}
