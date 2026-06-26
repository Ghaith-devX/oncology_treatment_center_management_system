import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/result.dart';
import '../../auth/controller/auth_controller.dart';
import '../api/notifications_api.dart';
import '../models/notification_model.dart';

enum NotifStatus { initial, loading, loaded, error }

class NotifState {
  final NotifStatus status;
  final List<NotificationModel> notifications;
  final String? error;

  const NotifState({
    this.status = NotifStatus.initial,
    this.notifications = const [],
    this.error,
  });

  NotifState copyWith({
    NotifStatus? status,
    List<NotificationModel>? notifications,
    String? error,
  }) {
    return NotifState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      error: error,
    );
  }

  int get unreadCount =>
      notifications.where((n) => !n.isRead).length;
}

class NotificationsController extends StateNotifier<NotifState> {
  final NotificationsApi _api;

  NotificationsController({required NotificationsApi api})
      : _api = api,
        super(const NotifState());

  Future<void> loadAll() async {
    state = state.copyWith(status: NotifStatus.loading);
    final result = await _api.getAll();
    if (result is Success<List<NotificationModel>>) {
      state = state.copyWith(
        status: NotifStatus.loaded,
        notifications: result.data,
        error: null,
      );
    } else if (result is Failure<List<NotificationModel>>) {
      state = state.copyWith(
          status: NotifStatus.error, error: result.message);
    }
  }

  Future<void> markAsRead(int id) async {
    final result = await _api.markAsRead(id);
    if (result is Success<void>) {
      state = state.copyWith(
        notifications: state.notifications.map((n) {
          return n.notificationId == id
              ? NotificationModel(
                  notificationId: n.notificationId,
                  userId: n.userId,
                  title: n.title,
                  message: n.message,
                  isRead: true,
                  createdAt: n.createdAt,
                )
              : n;
        }).toList(),
      );
    }
  }

  Future<String?> delete(int id) async {
    final result = await _api.delete(id);
    if (result is Success<void>) {
      state = state.copyWith(
        notifications:
            state.notifications.where((n) => n.notificationId != id).toList(),
      );
      return null;
    } else if (result is Failure<void>) {
      return result.message;
    }
    return 'Unknown error';
  }
}

final notificationsApiProvider = Provider<NotificationsApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationsApi(apiClient);
});

final notificationsControllerProvider =
    StateNotifierProvider<NotificationsController, NotifState>((ref) {
  return NotificationsController(api: ref.watch(notificationsApiProvider));
});
