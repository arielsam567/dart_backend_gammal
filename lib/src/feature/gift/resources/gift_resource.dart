import 'dart:async';
import 'dart:convert';
import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend/src/feature/auth/guard/auth_guard.dart';
import 'package:backend/src/feature/gift/errors/errors.dart';
import 'package:backend/src/feature/gift/models/gift_model.dart';
import 'package:backend/src/feature/gift/repositories/gift_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class GiftResource extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/create', _createGift, middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _createGift(
    Injector injector,
    Request request,
    ModularArguments arguments,
  ) async {
    final extractor = injector.get<RequestExtractor>();
    final giftRepository = injector.get<GiftRepository>();
    final data = arguments.data as Map;

    final token = extractor.getAuthBearerToken(request);

    try {
      final GiftModel gift = await giftRepository.create(token: token, map: data);
      return Response.ok(jsonEncode(gift.toMap()));
    } on GiftException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }
}
