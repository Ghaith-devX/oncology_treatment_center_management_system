import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/utils/date_time_parsing.dart';
import '../models/lab_model.dart';
import '../controller/laboratory_controller.dart';

class LaboratoryListScreen extends ConsumerStatefulWidget {
  const LaboratoryListScreen({super.key});

  @override
  ConsumerState<LaboratoryListScreen> createState() =>
      _LaboratoryListScreenState();
}

class _LaboratoryListScreenState extends ConsumerState<LaboratoryListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(laboratoryControllerProvider.notifier).loadAll();
    });
  }

  void _navigateToForm() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _LabFormScreen()),
    );
  }

  void _confirmDelete(int id) {
    ConfirmDialog.show(
      context,
      title: AppStrings.confirmDelete,
      message: AppStrings.confirmDelete,
      onConfirm: () async {
        final error =
            await ref.read(laboratoryControllerProvider.notifier).delete(id);
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
    final state = ref.watch(laboratoryControllerProvider);
    final controller = ref.read(laboratoryControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.laboratory),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToForm,
          ),
        ],
      ),
      body: switch (state.status) {
        LabStatus.initial || LabStatus.loading => const LoadingView(),
        LabStatus.error => ErrorView(
            message: state.error ?? AppStrings.errorOccurred,
            onRetry: () => controller.loadAll(),
          ),
        LabStatus.loaded => state.labs.isEmpty
            ? const EmptyStateView(message: 'لا توجد نتائج مختبر')
            : RefreshIndicator(
                onRefresh: () => controller.loadAll(),
                child: ListView.builder(
                  itemCount: state.labs.length,
                  itemBuilder: (_, i) {
                    final lab = state.labs[i];
                    return Card(
                      child: ListTile(
                        title: Text(lab.testType ?? 'تحليل'),
                        subtitle: Text(
                          'التاريخ: ${DateTimeParsing.formatDate(lab.testDate)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: AppColors.danger,
                          onPressed: () => _confirmDelete(lab.labId),
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

class _LabFormScreen extends ConsumerStatefulWidget {
  const _LabFormScreen();

  @override
  ConsumerState<_LabFormScreen> createState() => _LabFormScreenState();
}

class _LabFormScreenState extends ConsumerState<_LabFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _testTypeController = TextEditingController();
  final _testDateController = TextEditingController();
  final _hemoglobinController = TextEditingController();
  final _wbcController = TextEditingController();
  final _neutrophilsController = TextEditingController();
  final _plateletsController = TextEditingController();
  final _creatinineController = TextEditingController();
  final _ureaController = TextEditingController();
  final _resultNoteController = TextEditingController();

  @override
  void dispose() {
    _patientIdController.dispose();
    _testTypeController.dispose();
    _testDateController.dispose();
    _hemoglobinController.dispose();
    _wbcController.dispose();
    _neutrophilsController.dispose();
    _plateletsController.dispose();
    _creatinineController.dispose();
    _ureaController.dispose();
    _resultNoteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final lab = LabModel(
      labId: 0,
      patientId: int.tryParse(_patientIdController.text.trim()) ?? 0,
      testType: _testTypeController.text.trim(),
      testDate: _testDateController.text.trim(),
      hemoglobin: double.tryParse(_hemoglobinController.text.trim()),
      wbc: double.tryParse(_wbcController.text.trim()),
      neutrophils: double.tryParse(_neutrophilsController.text.trim()),
      platelets: double.tryParse(_plateletsController.text.trim()),
      creatinine: double.tryParse(_creatinineController.text.trim()),
      urea: double.tryParse(_ureaController.text.trim()),
      resultNote: _resultNoteController.text.trim(),
    );

    final error =
        await ref.read(laboratoryControllerProvider.notifier).create(lab);
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
      appBar: AppBar(title: const Text('إضافة تحليل')),
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
                controller: _testTypeController,
                decoration: const InputDecoration(labelText: AppStrings.testType),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _testDateController,
                decoration: const InputDecoration(labelText: 'تاريخ التحليل'),
              ),
              const SizedBox(height: 16),
              const Text('النتائج:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hemoglobinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'الهيموجلوبين'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _wbcController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'WBC'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _neutrophilsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Neutrophils'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _plateletsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Platelets'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _creatinineController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Creatinine'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ureaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Urea'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _resultNoteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: AppStrings.resultNote,
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
