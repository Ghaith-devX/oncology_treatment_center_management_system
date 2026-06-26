import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/endpoints.dart';
import '../../../shared/utils/result.dart';
import '../models/notification_model.dart';

class NotificationsApi {
  final ApiClient _client;

  NotificationsApi(this._client);

  Future<Result<List<NotificationModel>>> getAll() async {
    try {
      final response = await _client.dio.get(Endpoints.notifications);
      final list = (response.data as List)
          .map((e) =>
              NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<void>> markAsRead(int id) async {
    try {
      await _client.dio.put(
        Endpoints.notificationById(id.toString()),
        data: {'isRead': true},
      );
      return const Success(null);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      await _client.dio.delete(Endpoints.notificationById(id.toString()));
      return const Success(null);
    } on DioException catch (e) {
      return Failure.fromApiException(ApiException.fromDioError(e));
    } catch (e) {
      return Failure.unexpected(e.toString());
    }
  }
}
