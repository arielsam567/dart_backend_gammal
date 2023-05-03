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
        //create
        Route.post('/create', _createGift, middlewares: [AuthGuard()]),
        Route.get('/:id', _getById),
        Route.get('/user/:id', _getByUserId),
        Route.get('/', _getAll),
        Route.get('/:id/details', _getByIdWithDetails),
      ];

  FutureOr<Response> _getAll(
    Injector injector,
    Request request,
    ModularArguments arguments,
  ) async {
    final giftRepository = injector.get<GiftRepository>();

    try {
      int limit = int.parse(request.url.queryParameters['limit'] ?? '10');
      int offset = int.parse(request.url.queryParameters['offset'] ?? '0');

      final List<GiftModel> gifts = await giftRepository.getAll(limit, offset);
      return Response.ok(jsonEncode(gifts.map((e) => e.toMap()).toList()));
    } on GiftException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _createGift(Injector injector, Request request, ModularArguments arguments) async {
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

  FutureOr<Response> _getById(Injector injector, ModularArguments arguments) async {
    final giftRepository = injector.get<GiftRepository>();
    final String id = arguments.params['id'];
    try {
      final GiftModel gift = await giftRepository.getById(id);
      return Response.ok(jsonEncode(gift.toMap()));
    } on GiftException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _getByIdWithDetails(Injector injector, ModularArguments arguments) async {
    final giftRepository = injector.get<GiftRepository>();
    final String id = arguments.params['id'];
    try {
      final GiftModel gift = await giftRepository.getByIdWithDetails(id);
      return Response.ok(jsonEncode(gift.toMap()));
    } on GiftException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _getByUserId(Injector injector, ModularArguments arguments) async {
    final giftRepository = injector.get<GiftRepository>();
    final String id = arguments.params['id'];
    try {
      final List<GiftModel> gifts = await giftRepository.getByUserId(id);
      return Response.ok(jsonEncode(gifts.map((e) => e.toMap()).toList()));
    } on GiftException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }
}
