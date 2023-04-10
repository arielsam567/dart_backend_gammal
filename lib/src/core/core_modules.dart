import 'services/bcrypt/bcrypt_service.dart';
import 'services/bcrypt/bcrypt_service_imp.dart';
import 'services/database/postgres/postgres_database.dart';
import 'services/database/remove_database.dart';
import 'services/dot_env/dot_env_service.dart';
import 'services/jwt/jwt_service.dart';
import 'services/jwt/jwt_service_imp.dart';
import 'services/request_extractor/request_extractor.dart';
import 'package:shelf_modular/shelf_modular.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService(), export: true),
        Bind.singleton<RemoteDatabase>((i) => PostgressDatabase(i()), export: true),
        Bind.singleton<BcryptService>((i) => BCryptServiceImp(), export: true),
        Bind.singleton<RequestExtractor>((i) => RequestExtractor(), export: true),
        Bind.singleton<JwtService>((i) => JwtServiceImp(i()), export: true),
      ];
}
