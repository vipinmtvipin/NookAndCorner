class ApiException implements Exception {
  final String? message;
  final String? errorCode;

  const ApiException({
    this.message,
    this.errorCode,
  });

  @override
  String toString() {
    return 'ApiException(message: $message, errorCode: $errorCode)';
  }
}
