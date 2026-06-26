import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/stat_card.dart';
import '../controller/dashboard_controller.dart';
import '../widgets/quick_actions.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardControllerProvider.notifier).loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
      ),
      body: stats.isLoading
          ? const LoadingView()
          : stats.error != null
              ? ErrorView(
                  message: stats.error!,
                  onRetry: () =>
                      ref.read(dashboardControllerProvider.notifier).loadStats(),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(dashboardControllerProvider.notifier).loadStats(),
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'مرحباً بك في نظام الإدارة',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                label: AppStrings.patients,
                                value: stats.patientCount.toString(),
                                icon: Icons.people_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatCard(
                                label: AppStrings.employees,
                                value: stats.employeeCount.toString(),
                                icon: Icons.badge_outlined,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      QuickActions(
                        onAddPatient: () =>
                            context.goNamed('patientForm'),
                        onAddEmployee: () =>
                            context.goNamed('employeeForm'),
                        onViewPatients: () =>
                            context.goNamed('patients'),
                        onViewEmployees: () =>
                            context.goNamed('employees'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
