import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

FutureOr<Response> swaggerHandler(Request request) {
  final String path = 'specs/swagger.yaml';
  final Handler handler = SwaggerUI(
    path,
    title: 'Swagger UI',
    deepLink: true,
  );
  return handler(request);
}
