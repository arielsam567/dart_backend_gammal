import 'package:backend/src/core/services/database/postgres/postgres_database.dart';
import 'package:backend/src/core/services/database/remove_database.dart';
import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend/src/feature/user/user_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.instance<DotEnvService>(DotEnvService.instance),
        Bind.singleton<RemoteDatabase>((i) => PostgressDatabase(i()))
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(UserResource()),
      ];
}
