class NoInternetException implements Exception {
  final String message;

  NoInternetException([this.message = 'No Internet connection']);

  @override
  String toString() => 'NoInternetException: $message';
}

class RequestTimeoutException implements Exception {
  final String message;

  RequestTimeoutException([this.message = 'Request timed out']);

  @override
  String toString() => 'RequestTimeoutException: $message';
}
