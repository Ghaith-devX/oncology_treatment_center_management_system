import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/role_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/role_badge.dart';
import '../controller/users_controller.dart';
import '../models/user_model.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(usersControllerProvider.notifier).loadAll();
    });
  }

  void _navigateToForm() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _UserFormScreen()),
    );
  }

  void _confirmDeactivate(UserModel user) {
    ConfirmDialog.show(
      context,
      title: 'تعطيل المستخدم',
      message: 'هل أنت متأكد من تعطيل المستخدم ${user.fullName}؟',
      confirmLabel: 'تعطيل',
      onConfirm: () async {
        final error = await ref
            .read(usersControllerProvider.notifier)
            .update(user.userId, {'isActive': false});
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
    final state = ref.watch(usersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.users),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToForm,
          ),
        ],
      ),
      body: switch (state.status) {
        UsersStatus.initial || UsersStatus.loading => const LoadingView(),
        UsersStatus.error => ErrorView(
            message: state.error ?? AppStrings.errorOccurred,
            onRetry: () =>
                ref.read(usersControllerProvider.notifier).loadAll(),
          ),
        UsersStatus.loaded => state.users.isEmpty
            ? const EmptyStateView(message: 'لا يوجد مستخدمين')
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(usersControllerProvider.notifier).loadAll(),
                child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (_, i) {
                    final user = state.users[i];
                    return _UserCard(
                      user: user,
                      onDeactivate: user.isActive
                          ? () => _confirmDeactivate(user)
                          : null,
                    );
                  },
                ),
              ),
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onDeactivate;

  const _UserCard({required this.user, this.onDeactivate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: user.isActive
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.textSecondaryLight.withValues(alpha: 0.12),
              child: Text(
                user.fullName[0].toUpperCase(),
                style: TextStyle(
                  color: user.isActive
                      ? AppColors.primary
                      : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  RoleBadge(role: RoleType.fromRoleName(user.roleName)),
                ],
              ),
            ),
            if (onDeactivate != null)
              IconButton(
                onPressed: onDeactivate,
                icon: Icon(
                  Icons.toggle_off_outlined,
                  color: AppColors.warning,
                ),
                tooltip: 'تعطيل',
              ),
          ],
        ),
      ),
    );
  }
}

class _UserFormScreen extends ConsumerStatefulWidget {
  const _UserFormScreen();

  @override
  ConsumerState<_UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<_UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int? _selectedRoleId;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedRoleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار دور'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final data = {
      'fullName': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
      'roleId': _selectedRoleId,
    };

    final error = await ref.read(usersControllerProvider.notifier).create(data);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.danger),
      );
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.success),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(usersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مستخدم'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.fullName,
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? AppStrings.requiredField : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: AppStrings.email,
                ),
                validator: (v) => v == null || !v.contains('@')
                    ? AppStrings.invalidEmail
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: AppStrings.password,
                ),
                validator: (v) =>
                    v == null || v.length < 6 ? AppStrings.passwordMinLength : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _selectedRoleId,
                decoration: const InputDecoration(
                  labelText: 'الدور',
                ),
                items: state.roles
                    .map((r) => DropdownMenuItem(
                          value: r.roleId,
                          child: Text(r.roleName),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedRoleId = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isSubmitting ? null : _submit,
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AppStrings.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
