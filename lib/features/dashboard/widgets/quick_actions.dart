import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  final void Function()? onAddPatient;
  final void Function()? onAddEmployee;
  final void Function()? onViewPatients;
  final void Function()? onViewEmployees;

  const QuickActions({
    super.key,
    this.onAddPatient,
    this.onAddEmployee,
    this.onViewPatients,
    this.onViewEmployees,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إجراءات سريعة',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionChip(
                icon: Icons.person_add,
                label: AppStrings.addPatient,
                onTap: onAddPatient,
              ),
              _ActionChip(
                icon: Icons.people,
                label: AppStrings.patients,
                onTap: onViewPatients,
              ),
              _ActionChip(
                icon: Icons.person_add_alt_1,
                label: AppStrings.addEmployee,
                onTap: onAddEmployee,
              ),
              _ActionChip(
                icon: Icons.badge,
                label: AppStrings.employees,
                onTap: onViewEmployees,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: AppColors.primary),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
