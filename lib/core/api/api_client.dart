import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';

class ApiClient {
  late final Dio dio;

  ApiClient({
    required SecureStorageService secureStorage,
  }) {
    final baseOptions = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
    );

    dio = Dio(baseOptions);

    dio.interceptors.addAll([
      AuthInterceptor(
        secureStorage: secureStorage,
      ),
      if (kDebugMode)
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
    ]);
  }
}
