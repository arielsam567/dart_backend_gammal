import 'dart:io';

class DotEnvService {
  DotEnvService._() {
    _init();
  }

  final Map<String, String> _env = {};

  static DotEnvService instance = DotEnvService._();

  void _init([String path = '.env']) {
    final File file = File(path);
    final envText = file.readAsStringSync();

    for (final line in envText.split('\n')) {
      final keyValue = line.split('=');
      if (keyValue.length == 2) {
        _env[keyValue[0]] = keyValue[1];
      }
    }
  }

  String? get(String key) {
    return _env[key];
  }
}
