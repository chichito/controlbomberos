enum ErrorCode { validation, database, insert, timeout, unknown, notdata }

class Result<T> {
  final bool success;
  final T? data;
  final String? message;
  final ErrorCode? code;
  final Object? error;

  const Result({
    required this.success,
    this.data,
    this.message,
    this.code,
    this.error,
  });

  factory Result.ok(T data, {String? message}) =>
      Result(success: true, data: data, message: message);

  factory Result.fail({ErrorCode? code, String? message, Object? error}) =>
      Result(success: false, code: code, message: message, error: error);
}
