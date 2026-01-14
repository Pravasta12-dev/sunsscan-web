import 'package:sun_scan/core/exception/app_exception.dart';

class CustomException extends AppException {
  CustomException(String message, {int code = -2}) : super(message: message, code: code);
}
