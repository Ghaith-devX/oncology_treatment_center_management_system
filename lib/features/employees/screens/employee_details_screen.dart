import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../controller/employees_controller.dart';

class EmployeeDetailsScreen extends ConsumerStatefulWidget {
  final int employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  ConsumerState<EmployeeDetailsScreen> createState() =>
      _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState
    extends ConsumerState<EmployeeDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(employeesControllerProvider.notifier)
          .loadById(widget.employeeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeesControllerProvider);
    final employee = state.selectedEmployee;

    return Scaffold(
      appBar: AppBar(
        title: Text(employee?.fullName ?? AppStrings.employeeDetails),
      ),
      body: switch (state.status) {
        EmployeesStatus.initial || EmployeesStatus.loading =>
          const LoadingView(),
        EmployeesStatus.error => ErrorView(
            message: state.error ?? AppStrings.errorOccurred,
            onRetry: () => ref
                .read(employeesControllerProvider.notifier)
                .loadById(widget.employeeId),
          ),
        EmployeesStatus.loaded => employee == null
            ? const ErrorView(message: AppStrings.noData)
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _DetailRow(label: AppStrings.fullName, value: employee.fullName),
                  _DetailRow(label: AppStrings.gender, value: employee.gender ?? '--'),
                  _DetailRow(label: AppStrings.birthDate, value: employee.birthDate ?? '--'),
                  _DetailRow(label: AppStrings.phone, value: employee.phone ?? '--'),
                  _DetailRow(label: AppStrings.email, value: employee.email ?? '--'),
                  _DetailRow(label: AppStrings.address, value: employee.address ?? '--'),
                  _DetailRow(label: AppStrings.nationalId, value: employee.nationalId ?? '--'),
                  _DetailRow(label: AppStrings.position, value: employee.position ?? '--'),
                  _DetailRow(label: AppStrings.department, value: employee.department ?? '--'),
                  _DetailRow(label: AppStrings.hireDate, value: employee.hireDate ?? '--'),
                  _DetailRow(label: AppStrings.salary, value: employee.salary?.toString() ?? '--'),
                  _DetailRow(label: AppStrings.qualification, value: employee.qualification ?? '--'),
                  _DetailRow(label: AppStrings.status, value: employee.status ?? '--'),
                  _DetailRow(label: AppStrings.note, value: employee.note ?? '--'),
                ],
              ),
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
