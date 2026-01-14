import 'dart:convert';

import 'api_exception.dart';

class ApiErrorHandler {
  static ApiException handlerError({required int statusCode, String message = ''}) {
    final parsedMessage = _extractMessage(message);

    switch (statusCode) {
      case 400:
        return BadRequestException(message: parsedMessage);
      case 401:
        return UnauthorizedException(message: parsedMessage);
      case 402:
        return PaymentRequiredException(message: parsedMessage);
      case 403:
        return ForbiddenException(message: parsedMessage);
      case 404:
        return NotFoundException(message: parsedMessage);
      case 408:
        return RequestTimeoutException(message: parsedMessage);
      case 405:
        return MethodNotAllowedException(message: parsedMessage);
      case 406:
        return NotAcceptableException(message: parsedMessage);
      case 500:
        return InternalServerErrorException(message: parsedMessage);
      case 501:
        return NotImplementedException(message: parsedMessage);
      case 502:
        return BadGatewayException(message: parsedMessage);
      default:
        return ApiException(message: 'Received invalid status code: $statusCode');
    }
  }

  /// 🔧 Extract message dari response body
  static String _extractMessage(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] != null) {
          return decoded['message'].toString();
        }
        if (decoded['error'] != null) {
          return decoded['error'].toString();
        }
      }

      return body;
    } catch (_) {
      // body bukan JSON
      return body;
    }
  }
}
