import 'dart:convert';

import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final extractior = RequestExtractor();

  test('getAuthBearerToken', () async {
    final request = Request(
      'GET',
      Uri.parse('http://localhost:4466/'),
      headers: {'authorization': 'bearer 1234567890'},
    );
    final token = extractior.getAuthBearerToken(request);
    expect(token, '1234567890');
  });

  test('getAuthBasicToken', () async {
    final String credentialAuth = 'ariel@sam.com:123';
    final base64 = base64Encode(credentialAuth.codeUnits);
    final request = Request(
      'GET',
      Uri.parse('http://localhost:4466/'),
      headers: {'authorization': 'basic $base64'},
    );
    final LoginCredetial credetial = extractior.getAuthBasicToken(request);
    expect(credetial.email, 'ariel@sam.com');
    expect(credetial.password, '123');
  });
}
