import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../controller/notifications_controller.dart';

class NotificationsListScreen extends ConsumerStatefulWidget {
  const NotificationsListScreen({super.key});

  @override
  ConsumerState<NotificationsListScreen> createState() =>
      _NotificationsListScreenState();
}

class _NotificationsListScreenState
    extends ConsumerState<NotificationsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsControllerProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsControllerProvider);
    final controller = ref.read(notificationsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        actions: [
          if (state.unreadCount > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    state.unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: switch (state.status) {
        NotifStatus.initial || NotifStatus.loading => const LoadingView(),
        NotifStatus.error => ErrorView(
            message: state.error ?? AppStrings.errorOccurred,
            onRetry: () => controller.loadAll(),
          ),
        NotifStatus.loaded => state.notifications.isEmpty
            ? const EmptyStateView(message: AppStrings.noNotifications)
            : RefreshIndicator(
                onRefresh: () => controller.loadAll(),
                child: ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (_, i) {
                    final notif = state.notifications[i];
                    return Card(
                      color: notif.isRead ? null : AppColors.primary.withValues(alpha: 0.05),
                      child: ListTile(
                        title: Text(
                          notif.title ?? '',
                          style: TextStyle(
                            fontWeight:
                                notif.isRead ? FontWeight.normal : FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(notif.message ?? ''),
                        trailing: notif.isRead
                            ? IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: AppColors.danger,
                                onPressed: () => controller.delete(notif.notificationId),
                              )
                            : TextButton(
                                onPressed: () =>
                                    controller.markAsRead(notif.notificationId),
                                child: const Text(AppStrings.markAsRead),
                              ),
                      ),
                    );
                  },
                ),
              ),
      },
    );
  }
}
