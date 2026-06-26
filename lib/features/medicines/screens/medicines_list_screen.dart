import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../controller/medicines_controller.dart';
import '../models/medicine_model.dart';

class MedicinesListScreen extends ConsumerStatefulWidget {
  const MedicinesListScreen({super.key});

  @override
  ConsumerState<MedicinesListScreen> createState() =>
      _MedicinesListScreenState();
}

class _MedicinesListScreenState extends ConsumerState<MedicinesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicinesControllerProvider.notifier).loadAll();
    });
  }

  void _navigateToForm() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _MedicineFormScreen()),
    );
  }

  void _confirmDelete(int id) {
    ConfirmDialog.show(
      context,
      title: AppStrings.confirmDelete,
      message: AppStrings.confirmDelete,
      onConfirm: () async {
        final error =
            await ref.read(medicinesControllerProvider.notifier).delete(id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? AppStrings.success),
            backgroundColor: error != null ? AppColors.danger : AppColors.success,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicinesControllerProvider);
    final controller = ref.read(medicinesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicines),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToForm,
          ),
        ],
      ),
      body: switch (state.status) {
        MedicinesStatus.initial || MedicinesStatus.loading =>
          const LoadingView(),
        MedicinesStatus.error => ErrorView(
            message: state.error ?? AppStrings.errorOccurred,
            onRetry: () => controller.loadAll(),
          ),
        MedicinesStatus.loaded => state.medicines.isEmpty
            ? const EmptyStateView(message: 'لا توجد أدوية')
            : RefreshIndicator(
                onRefresh: () => controller.loadAll(),
                child: ListView.builder(
                  itemCount: state.medicines.length,
                  itemBuilder: (_, i) {
                    final med = state.medicines[i];
                    return Card(
                      child: ListTile(
                        title: Text(med.tradeName ?? 'دواء'),
                        subtitle: Text(med.activeIngredient ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: AppColors.danger,
                          onPressed: () => _confirmDelete(med.medicineId),
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

class _MedicineFormScreen extends ConsumerStatefulWidget {
  const _MedicineFormScreen();

  @override
  ConsumerState<_MedicineFormScreen> createState() =>
      _MedicineFormScreenState();
}

class _MedicineFormScreenState extends ConsumerState<_MedicineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _tradeNameController = TextEditingController();
  final _activeIngredientController = TextEditingController();
  final _doseController = TextEditingController();
  final _doseUnitController = TextEditingController();
  final _routeController = TextEditingController();

  @override
  void dispose() {
    _patientIdController.dispose();
    _tradeNameController.dispose();
    _activeIngredientController.dispose();
    _doseController.dispose();
    _doseUnitController.dispose();
    _routeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final medicine = MedicineModel(
      medicineId: 0,
      patientId: int.tryParse(_patientIdController.text.trim()) ?? 0,
      tradeName: _tradeNameController.text.trim(),
      activeIngredient: _activeIngredientController.text.trim(),
      route: _routeController.text.trim(),
      prescribedDose: double.tryParse(_doseController.text.trim()),
      doseUnit: _doseUnitController.text.trim(),
    );

    final error =
        await ref.read(medicinesControllerProvider.notifier).create(medicine);
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
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة دواء')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _patientIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'رقم المريض'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? AppStrings.requiredField : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tradeNameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.tradeName,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _activeIngredientController,
                decoration: const InputDecoration(
                  labelText: AppStrings.activeIngredient,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _doseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الجرعة الموصوفة',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _doseUnitController,
                decoration: const InputDecoration(
                  labelText: AppStrings.doseUnit,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _routeController,
                decoration: const InputDecoration(
                  labelText: AppStrings.route,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text(AppStrings.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
