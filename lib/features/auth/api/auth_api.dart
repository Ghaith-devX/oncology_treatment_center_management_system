import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/endpoints.dart';
import '../../../shared/utils/result.dart';
import '../models/auth_session.dart';
import '../models/login_request.dart';

class AuthApi {
  final ApiClient _client;

  AuthApi(this._client);

  Future<Result<AuthSession>> login(LoginRequest request) async {
    try {
      final response = await _client.dio.post(
        Endpoints.login,
        data: request.toJson(),
      );
      final session = AuthSession.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Success(session);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }
}
