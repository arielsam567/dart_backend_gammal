import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/services/bcrypt/bcrypt_service_imp.dart';
import 'package:backend/src/core/services/database/postgres/postgres_database.dart';
import 'package:backend/src/core/services/database/remove_database.dart';
import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend/src/feature/auth/auth_resource.dart';
import 'package:backend/src/feature/swagger/swagger_handler.dart';
import 'package:backend/src/feature/user/user_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService()),
        Bind.singleton<RemoteDatabase>((i) => PostgressDatabase(i())),
        Bind.singleton<BcryptService>((i) => BCryptServiceImp()),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/api/**', swaggerHandler),
        Route.resource(UserResource()),
        Route.resource(AuthResource()),
      ];
}
