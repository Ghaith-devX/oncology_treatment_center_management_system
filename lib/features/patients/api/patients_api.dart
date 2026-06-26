import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/endpoints.dart';
import '../../../shared/utils/result.dart';
import '../models/patient_model.dart';

class PatientsApi {
  final ApiClient _client;

  PatientsApi(this._client);

  Future<Result<List<PatientModel>>> getAll() async {
    try {
      final response = await _client.dio.get(Endpoints.patients);
      final list = (response.data as List)
          .map((e) => PatientModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<PatientModel>> getById(int id) async {
    try {
      final response = await _client.dio.get(Endpoints.patientById(id.toString()));
      return Success(PatientModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<PatientModel>> create(PatientModel patient) async {
    try {
      final response = await _client.dio.post(
        Endpoints.patients,
        data: patient.toJson(),
      );
      return Success(PatientModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<PatientModel>> update(int id, PatientModel patient) async {
    try {
      final response = await _client.dio.put(
        Endpoints.patientById(id.toString()),
        data: patient.toJson(),
      );
      return Success(PatientModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      await _client.dio.delete(Endpoints.patientById(id.toString()));
      return const Success(null);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }
}
