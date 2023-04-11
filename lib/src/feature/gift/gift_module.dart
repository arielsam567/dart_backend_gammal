import 'package:backend/src/feature/auth/datasources/auth_datasource_imp.dart';
import 'package:backend/src/feature/auth/repositories/auth_repository.dart';
import 'package:backend/src/feature/gift/datasources/auth_datasource_imp.dart';
import 'package:backend/src/feature/gift/repositories/gift_repository.dart';
import 'package:backend/src/feature/gift/resources/gift_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class GiftModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<AuthDatasource>((i) => AuthDatasourceImpl(i())),
        Bind.singleton<GiftDatasourceImpl>((i) => GiftDatasourceImpl(i())),
        Bind.singleton((i) => AuthRepository(i(), i(), i())),
        Bind.singleton((i) => GiftRepository(i(), i(), i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(GiftResource()),
      ];
}
