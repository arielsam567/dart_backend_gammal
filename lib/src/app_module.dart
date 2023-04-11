import 'package:backend/src/core/core_modules.dart';
import 'package:backend/src/feature/auth/auth_module.dart';
import 'package:backend/src/feature/gift/gift_module.dart';
import 'package:backend/src/feature/swagger/swagger_handler.dart';
import 'package:backend/src/feature/user/user_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        Route.get('/api/**', swaggerHandler),
        Route.resource(UserResource()),
        Route.module('/auth', module: AuthModule()),
        Route.module('/gift', module: GiftModule()),
      ];
}
