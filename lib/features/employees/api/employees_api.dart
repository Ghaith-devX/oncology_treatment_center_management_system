import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/endpoints.dart';
import '../../../shared/utils/result.dart';
import '../models/employee_model.dart';

class EmployeesApi {
  final ApiClient _client;

  EmployeesApi(this._client);

  Future<Result<List<EmployeeModel>>> getAll() async {
    try {
      final response = await _client.dio.get(Endpoints.employees);
      final list = (response.data as List)
          .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<EmployeeModel>> getById(int id) async {
    try {
      final response = await _client.dio.get(Endpoints.employeeById(id.toString()));
      return Success(EmployeeModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<EmployeeModel>> create(EmployeeModel employee) async {
    try {
      final response = await _client.dio.post(
        Endpoints.employees,
        data: employee.toJson(),
      );
      return Success(EmployeeModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<EmployeeModel>> update(int id, EmployeeModel employee) async {
    try {
      final response = await _client.dio.put(
        Endpoints.employeeById(id.toString()),
        data: employee.toJson(),
      );
      return Success(EmployeeModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      await _client.dio.delete(Endpoints.employeeById(id.toString()));
      return const Success(null);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }
}
