import '../../core/api/api_exception.dart';

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;
  final int? statusCode;
  final ApiException? exception;

  const Failure({
    required this.message,
    this.statusCode,
    this.exception,
  });

  factory Failure.fromApiException(ApiException e) {
    return Failure(
      message: e.message,
      statusCode: e.statusCode,
      exception: e,
    );
  }

  factory Failure.network(String message) => Failure(message: message);
  factory Failure.server(String message) => Failure(message: message);
  factory Failure.unauthorized(String message) => Failure(message: message);
  factory Failure.notFound(String message) => Failure(message: message);
  factory Failure.validation(String message) => Failure(message: message);
  factory Failure.unexpected(String message) => Failure(message: message);
}
