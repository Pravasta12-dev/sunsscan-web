import 'package:sun_scan/core/exception/app_exception.dart';

class CustomException extends AppException {
  CustomException(String message, {String code = 'UNKNOWN_ERROR'})
    : super(message: message, code: code);
}
