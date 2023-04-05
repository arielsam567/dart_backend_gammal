import 'package:backend/src/app_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

Future<Handler> startShelfModular() async {
  final handler = Modular(
    module: AppModule(),
    middlewares: [
      logRequests(),
      jsonResponse(),
    ],
  );
  return handler;
}

Middleware jsonResponse() {
  return (handler) {
    return (request) async {
      var response = await handler(request);

      if (response.headers['content-Type'] == null) {
        response = response.change(
          headers: {
            'content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*', // Required for CORS support to work
          },
        );
      }
      return response;
    };
  };
}
