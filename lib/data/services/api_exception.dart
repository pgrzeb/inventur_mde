class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String responseBody;

  ApiException(this.statusCode, this.message, this.responseBody);

  @override
  String toString() => 'ApiException: Status $statusCode. $message. Body: $responseBody';
}