import 'package:flutter/material.dart';
import '../../core/constants/role_constants.dart';
import '../../core/theme/app_colors.dart';

class RoleBadge extends StatelessWidget {
  final RoleType role;

  const RoleBadge({super.key, required this.role});

  Color get _color {
    switch (role) {
      case RoleType.admin:
        return AppColors.danger;
      case RoleType.doctor:
        return AppColors.info;
      case RoleType.reception:
        return AppColors.warning;
      case RoleType.patient:
        return AppColors.success;
      case RoleType.laboratory:
        return AppColors.secondary;
      case RoleType.unknown:
        return AppColors.textSecondaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role.label,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
