import 'package:backend/backend.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final Handler handler = await startShelfModular();
  final server = await io.serve(handler, '0.0.0.0', 4466);

  print('Serving at ${server.address.address}:${server.port} - OK');
}
