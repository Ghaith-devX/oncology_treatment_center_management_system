import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/endpoints.dart';
import '../../../shared/utils/result.dart';
import '../models/role_model.dart';

class RolesApi {
  final ApiClient _client;

  RolesApi(this._client);

  Future<Result<List<RoleModel>>> getAll() async {
    try {
      final response = await _client.dio.get(Endpoints.roles);
      final list = (response.data as List)
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }
}
