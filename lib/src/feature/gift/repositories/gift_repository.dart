import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:backend/src/feature/gift/datasources/auth_datasource_imp.dart';
import 'package:backend/src/feature/gift/errors/errors.dart';
import 'package:backend/src/feature/gift/models/gift_model.dart';

class GiftRepository {
  final BcryptService bcrypt;
  final JwtService jwt;
  final GiftDatasourceImpl datasource;

  GiftRepository(this.datasource, this.bcrypt, this.jwt);

  Future<GiftModel> create({required String token, required Map map}) async {
    final Map payload = jwt.getPayload(token);
    final String userId = payload['id'].toString();
    final Map json = await datasource.createGift(map: map, userId: userId);

    if (json.isEmpty) {
      throw GiftException(403, 'I DONT KNOW WHAT TO DO');
    }
    print('json: $json');
    return GiftModel.fromMap(json);
  }
}
