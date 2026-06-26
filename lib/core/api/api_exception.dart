import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final DioException? originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  factory ApiException.fromDioError(DioException error) {
    String message;
    int? statusCode;

    switch (error.type) {
      case DioExceptionType.cancel:
        message = 'تم إلغاء الطلب';
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'انتهت مهلة الاتصال';
      case DioExceptionType.badResponse:
        statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            message = 'طلب غير صحيح';
          case 401:
          case 403:
            message = 'غير مصرح. الرجاء تسجيل الدخول مرة أخرى';
          case 404:
            message = 'البيانات غير موجودة';
          case 409:
            message = 'تعارض مع البيانات الحالية';
          case 422:
            message = 'بيانات غير صالحة';
          case 500:
          case 502:
          case 503:
            message = 'خطأ في الخادم الداخلي';
          default:
            message = 'حدث خطأ (${error.response?.statusMessage ?? ''})';
        }
      case DioExceptionType.connectionError:
        message = 'لا يوجد اتصال بالإنترنت';
      case DioExceptionType.badCertificate:
        message = 'خطأ في شهادة الأمان';
      case DioExceptionType.unknown:
        message = error.message ?? 'حدث خطأ غير متوقع';
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      originalError: error,
    );
  }

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}
