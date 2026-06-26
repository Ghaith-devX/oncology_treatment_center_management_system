import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/endpoints.dart';
import '../../../shared/utils/result.dart';
import '../models/lab_model.dart';

class LaboratoryApi {
  final ApiClient _client;

  LaboratoryApi(this._client);

  Future<Result<List<LabModel>>> getAll() async {
    try {
      final response = await _client.dio.get(Endpoints.laboratory);
      final list = (response.data as List)
          .map((e) => LabModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<LabModel>> getById(int id) async {
    try {
      final response = await _client.dio.get(Endpoints.laboratoryById(id.toString()));
      return Success(LabModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<LabModel>> create(LabModel lab) async {
    try {
      final response = await _client.dio.post(
        Endpoints.laboratory,
        data: lab.toJson(),
      );
      return Success(LabModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<LabModel>> update(int id, LabModel lab) async {
    try {
      final response = await _client.dio.put(
        Endpoints.laboratoryById(id.toString()),
        data: lab.toJson(),
      );
      return Success(LabModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      await _client.dio.delete(Endpoints.laboratoryById(id.toString()));
      return const Success(null);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }
}
