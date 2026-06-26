import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/endpoints.dart';
import '../../../shared/utils/result.dart';
import '../models/user_model.dart';

class UsersApi {
  final ApiClient _client;

  UsersApi(this._client);

  Future<Result<List<UserModel>>> getAll() async {
    try {
      final response = await _client.dio.get(Endpoints.users);
      final list = (response.data as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<UserModel>> getById(int id) async {
    try {
      final response = await _client.dio.get(Endpoints.userById(id.toString()));
      return Success(UserModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<UserModel>> create(Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.post(Endpoints.users, data: data);
      return Success(UserModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<UserModel>> update(int id, Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.put(
        Endpoints.userById(id.toString()),
        data: data,
      );
      return Success(UserModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      await _client.dio.delete(Endpoints.userById(id.toString()));
      return const Success(null);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }
}
