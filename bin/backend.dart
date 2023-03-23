//import shelf_io as io;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  Pipeline pipeline = Pipeline().addMiddleware(log());

  final server = await io.serve(pipeline.addHandler(handler), '0.0.0.0', 4466);

  print('Serving at ${server.address.address}:${server.port} - OK');
}

Response handler(Request request) {
  return Response.ok('Hello, world!');
}

Middleware log() {
  return (handler) {
    return (request) async {
      print('Request: ${request.method} ${request.requestedUri}');
      var response = await handler(request);
      print('Response: ${response.statusCode}');
      return response;
    };
  };
}
