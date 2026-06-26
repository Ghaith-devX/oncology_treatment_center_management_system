import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/endpoints.dart';
import '../../../shared/utils/result.dart';
import '../models/medicine_model.dart';

class MedicinesApi {
  final ApiClient _client;

  MedicinesApi(this._client);

  Future<Result<List<MedicineModel>>> getAll() async {
    try {
      final response = await _client.dio.get(Endpoints.medicines);
      final list = (response.data as List)
          .map((e) => MedicineModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<MedicineModel>> getById(int id) async {
    try {
      final response = await _client.dio.get(Endpoints.medicineById(id.toString()));
      return Success(
          MedicineModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<MedicineModel>> create(MedicineModel medicine) async {
    try {
      final response = await _client.dio.post(
        Endpoints.medicines,
        data: medicine.toJson(),
      );
      return Success(
          MedicineModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<MedicineModel>> update(int id, MedicineModel medicine) async {
    try {
      final response = await _client.dio.put(
        Endpoints.medicineById(id.toString()),
        data: medicine.toJson(),
      );
      return Success(
          MedicineModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      await _client.dio.delete(Endpoints.medicineById(id.toString()));
      return const Success(null);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }
}
