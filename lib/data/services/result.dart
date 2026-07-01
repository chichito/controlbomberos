enum StatusResult { initial, loading, success, error, empty }

enum ErrorCode {
  validation,
  database,
  insert,
  timeout,
  network,
  unauthorized,
  notFound,
  unknown,
  notdata,
}

class Result<T> {
  final bool success;
  final T? data;
  final String? message;
  final ErrorCode? code;
  final Object? error;

  const Result._({
    required this.success,
    this.data,
    this.message,
    this.code,
    this.error,
  });

  bool get isSuccess => data != null;
  bool get isFailure => data == null;

  factory Result.ok(T data, {String? message}) =>
      Result._(success: true, data: data, message: message);

  factory Result.fail({ErrorCode? code, String? message, Object? error}) =>
      Result._(success: false, code: code, message: message, error: error);
}
