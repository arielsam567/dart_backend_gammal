import 'package:backend/src/feature/user/user_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.resource(UserResource()),
      ];
}
