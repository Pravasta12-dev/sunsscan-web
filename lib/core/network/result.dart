abstract class Status {
  static var success = Success();
  static var error = Error();
  static var noInternet = NoInternet();
}

class Success extends Status {}

class Error extends Status {}

class NoInternet extends Status {}

class Result<R> {
  late R data;
  late Status status;

  int code;
  String message;
  String? error;

  Result.success(this.data, {this.code = 200, this.message = ''}) : status = Status.success;

  Result.error(this.error, {this.code = -1, this.message = ''}) : status = Status.error;

  Result.noInternet({this.code = -1, this.message = 'No Internet Connection'})
    : status = Status.noInternet;
}
