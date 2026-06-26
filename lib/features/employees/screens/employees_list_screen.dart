import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../controller/employees_controller.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_search_bar.dart';
import 'employee_details_screen.dart';
import 'employee_form_screen.dart';

class EmployeesListScreen extends ConsumerStatefulWidget {
  const EmployeesListScreen({super.key});

  @override
  ConsumerState<EmployeesListScreen> createState() =>
      _EmployeesListScreenState();
}

class _EmployeesListScreenState extends ConsumerState<EmployeesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeesControllerProvider.notifier).loadAll();
    });
  }

  void _navigateToDetails(int employeeId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmployeeDetailsScreen(employeeId: employeeId),
      ),
    );
  }

  void _navigateToForm() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EmployeeFormScreen()),
    );
  }

  void _confirmDelete(int id, String name) {
    ConfirmDialog.show(
      context,
      title: AppStrings.confirmDelete,
      message: '${AppStrings.confirmDelete} $name؟',
      onConfirm: () async {
        final error =
            await ref.read(employeesControllerProvider.notifier).delete(id);
        if (!mounted) return;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: AppColors.danger),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.success),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeesControllerProvider);
    final controller = ref.read(employeesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.employees),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToForm,
          ),
        ],
      ),
      body: switch (state.status) {
        EmployeesStatus.initial || EmployeesStatus.loading =>
          const LoadingView(),
        EmployeesStatus.error => ErrorView(
            message: state.error ?? AppStrings.errorOccurred,
            onRetry: () => controller.loadAll(),
          ),
        EmployeesStatus.loaded => Column(
            children: [
              EmployeeSearchBar(
                query: state.searchQuery,
                onChanged: controller.setSearchQuery,
              ),
              Expanded(
                child: state.filteredEmployees.isEmpty
                    ? EmptyStateView(
                        message: state.searchQuery.isEmpty
                            ? AppStrings.noEmployees
                            : '${AppStrings.noEmployees} (${AppStrings.search})',
                        actionLabel: AppStrings.addFirstEmployee,
                        onAction: _navigateToForm,
                        icon: Icons.person_add_outlined,
                      )
                    : RefreshIndicator(
                        onRefresh: () => controller.loadAll(),
                        child: ListView.builder(
                          itemCount: state.filteredEmployees.length,
                          itemBuilder: (_, i) {
                            final employee = state.filteredEmployees[i];
                            return EmployeeCard(
                              employee: employee,
                              onTap: () =>
                                  _navigateToDetails(employee.employeeId),
                              onDelete: () => _confirmDelete(
                                  employee.employeeId, employee.fullName),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
      },
    );
  }
}
