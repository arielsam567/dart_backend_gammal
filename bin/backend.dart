//import shelf_io as io;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final server = await io.serve(
    (request) => Response(
      200,
      body: 'Hello, world',
    ),
    '0.0.0.0',
    4466,
  );

  print('Serving at ${server.address.address}:${server.port} - OK');
}
