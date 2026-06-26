import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/endpoints.dart';
import '../../../shared/utils/result.dart';
import '../models/treatment_session_model.dart';

class TreatmentSessionsApi {
  final ApiClient _client;

  TreatmentSessionsApi(this._client);

  Future<Result<List<TreatmentSessionModel>>> getAll() async {
    try {
      final response = await _client.dio.get(Endpoints.treatmentSessions);
      final list = (response.data as List)
          .map((e) =>
              TreatmentSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<TreatmentSessionModel>> getById(int id) async {
    try {
      final response = await _client.dio
          .get(Endpoints.treatmentSessionById(id.toString()));
      return Success(TreatmentSessionModel.fromJson(
          response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<TreatmentSessionModel>> create(
      TreatmentSessionModel session) async {
    try {
      final response = await _client.dio.post(
        Endpoints.treatmentSessions,
        data: session.toJson(),
      );
      return Success(TreatmentSessionModel.fromJson(
          response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<TreatmentSessionModel>> update(
      int id, TreatmentSessionModel session) async {
    try {
      final response = await _client.dio.put(
        Endpoints.treatmentSessionById(id.toString()),
        data: session.toJson(),
      );
      return Success(TreatmentSessionModel.fromJson(
          response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      await _client.dio.delete(Endpoints.treatmentSessionById(id.toString()));
      return const Success(null);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }
}
