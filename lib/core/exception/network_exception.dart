import 'package:sun_scan/core/exception/app_exception.dart';

class NetworkException extends AppException {
  NetworkException(String message) : super(message: message, code: -1);
}

class NoInternetException extends NetworkException {
  NoInternetException() : super('No Internet Connection');
}

class TimeoutNetworkException extends NetworkException {
  TimeoutNetworkException() : super('Request Timeout');
}
