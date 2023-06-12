import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend/src/feature/auth/guard/auth_guard.dart';
import 'package:backend/src/feature/gift/errors/errors.dart';
import 'package:backend/src/feature/gift/models/gift_model.dart';
import 'package:backend/src/feature/gift/repositories/gift_repository.dart';
import 'package:mime/mime.dart';
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
        Route.post('/photo', _photo),
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
    final Map<String, dynamic> data = arguments.data as Map<String, dynamic>;

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

  FutureOr<Response> _photo(Injector injector, ModularArguments arguments, Request request) async {
    try {
      print('request.headers: ${request.headers}');

      ///

      List<int> dataBytes = [];

      // await for (var data in request) {
      //   dataBytes.addAll(data);
      // }

      request.read().listen((data) {
        dataBytes.addAll(data);
      });
      print('dataBytes: $dataBytes');

      String boundary = request.headers['content-type']!.split('boundary=')[1];
      final transformer = MimeMultipartTransformer(boundary);
      final uploadDirectory = './upload';

      final bodyStream = Stream.fromIterable([dataBytes]);
      final parts = await transformer.bind(bodyStream).toList();

      for (var part in parts) {
        print(part.headers);
        final contentDisposition = part.headers['content-disposition'];
        final filename = RegExp(r'filename="([^"]*)"').firstMatch(contentDisposition!)!.group(1);
        final content = await part.toList();

        if (!Directory(uploadDirectory).existsSync()) {
          await Directory(uploadDirectory).create();
        }

        await File('$uploadDirectory/$filename').writeAsBytes(content[0]);
      }

      

      return Response.ok(jsonEncode({'photo': 'teste'}));
    } on GiftException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }
}
