import 'dart:convert';

class GiftException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final int statusCode;

  GiftException(this.statusCode, this.message, [this.stackTrace]);

  String toJson() {
    return jsonEncode({'GiftException ': message});
  }

  @override
  String toString() => 'GiftException(message: $message, stackTrace: $stackTrace, statusCode: $statusCode)';
}
