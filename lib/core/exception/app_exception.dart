class AppException {
  final String message;
  final int? code;

  AppException({required this.message, this.code});

  @override
  String toString() {
    return 'AppException(code: $code, message: $message)';
  }
}
