import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:backend/src/feature/gift/datasources/auth_datasource_imp.dart';
import 'package:backend/src/feature/gift/errors/errors.dart';
import 'package:backend/src/feature/gift/models/gift_model.dart';

class GiftRepository {
  final BcryptService bcrypt;
  final JwtService jwt;
  final GiftDatasource datasource;

  GiftRepository(this.datasource, this.bcrypt, this.jwt);

  Future<GiftModel> create({required String token, required Map map}) async {
    final Map payload = jwt.getPayload(token);
    final int userId = payload['id'];
    final Map json = await datasource.createGift(map: map, userId: userId);

    if (json.isEmpty) {
      throw GiftException(403, 'I DONT KNOW WHAT TO DO');
    }
    return GiftModel.fromMap(json);
  }

  Future<List<GiftModel>> getAll(int limit, int offset) async {
    final Map json = await datasource.getAllGifts(limit, offset);

    if (json.isEmpty) {
      throw GiftException(403, 'I DONT KNOW WHAT TO DO');
    }

    return json.values.map((e) => GiftModel.fromMap(e['Gift'])).toList();
  }

  Future<GiftModel> getById(String id) async {
    final Map json = await datasource.getGiftById(id);

    if (json.isEmpty) {
      throw GiftException(403, 'gift not found');
    }
    print('json: $json');
    return GiftModel.fromMap(json);
  }

  Future<GiftModel> getByIdWithDetails(String id) async {
    final Map json = await datasource.getGiftById(id);

    if (json.isEmpty) {
      throw GiftException(403, 'gift not found');
    }
    print('json: $json');
    return GiftModel.fromMap(json);
  }

  Future<List<GiftModel>> getByUserId(String userId) async {
    final int id = int.parse(userId);
    final Map json = await datasource.getGiftByUserId(id);

    if (json.isEmpty) {
      return [];
    }

    return json.values.map((e) => GiftModel.fromMap(e['Gift'])).toList();
  }
}
