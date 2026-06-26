import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/utils/date_time_parsing.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../models/treatment_session_model.dart';
import '../controller/treatment_sessions_controller.dart';

class TreatmentSessionsListScreen extends ConsumerStatefulWidget {
  const TreatmentSessionsListScreen({super.key});

  @override
  ConsumerState<TreatmentSessionsListScreen> createState() =>
      _TreatmentSessionsListScreenState();
}

class _TreatmentSessionsListScreenState
    extends ConsumerState<TreatmentSessionsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treatmentSessionsControllerProvider.notifier).loadAll();
    });
  }

  void _navigateToForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => const _SessionFormScreen()),
    );
  }

  void _confirmDelete(int id) {
    ConfirmDialog.show(
      context,
      title: AppStrings.confirmDelete,
      message: AppStrings.confirmDelete,
      onConfirm: () async {
        final error = await ref
            .read(treatmentSessionsControllerProvider.notifier)
            .delete(id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? AppStrings.success),
            backgroundColor:
                error != null ? AppColors.danger : AppColors.success,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentSessionsControllerProvider);
    final controller = ref.read(treatmentSessionsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.treatmentSessions),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToForm,
          ),
        ],
      ),
      body: switch (state.status) {
        SessionsStatus.initial || SessionsStatus.loading =>
          const LoadingView(),
        SessionsStatus.error => ErrorView(
            message: state.error ?? AppStrings.errorOccurred,
            onRetry: () => controller.loadAll(),
          ),
        SessionsStatus.loaded => state.sessions.isEmpty
            ? const EmptyStateView(message: 'لا توجد جلسات علاج')
            : RefreshIndicator(
                onRefresh: () => controller.loadAll(),
                child: ListView.builder(
                  itemCount: state.sessions.length,
                  itemBuilder: (_, i) {
                    final s = state.sessions[i];
                    return Card(
                      child: ListTile(
                        title: Text(s.sessionType ?? 'جلسة'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التاريخ: ${DateTimeParsing.formatDate(s.sessionDate)}',
                            ),
                            Text(
                              'الوقت: ${DateTimeParsing.formatTime(s.startTime)} - ${DateTimeParsing.formatTime(s.endTime)}',
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: AppColors.danger,
                          onPressed: () => _confirmDelete(s.sessionId),
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

class _SessionFormScreen extends ConsumerStatefulWidget {
  const _SessionFormScreen();

  @override
  ConsumerState<_SessionFormScreen> createState() =>
      _SessionFormScreenState();
}

class _SessionFormScreenState extends ConsumerState<_SessionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _sessionTypeController = TextEditingController();
  final _sessionDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _roomController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _patientIdController.dispose();
    _sessionTypeController.dispose();
    _sessionDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _roomController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final session = TreatmentSessionModel(
      sessionId: 0,
      patientId: int.tryParse(_patientIdController.text.trim()) ?? 0,
      sessionType: _sessionTypeController.text.trim(),
      sessionDate: _sessionDateController.text.trim(),
      startTime: _startTimeController.text.trim(),
      endTime: _endTimeController.text.trim(),
      room: _roomController.text.trim(),
      note: _noteController.text.trim(),
    );

    final error = await ref
        .read(treatmentSessionsControllerProvider.notifier)
        .create(session);
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
      appBar: AppBar(title: const Text('إضافة جلسة علاج')),
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
                controller: _sessionTypeController,
                decoration: const InputDecoration(
                  labelText: AppStrings.sessionType,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sessionDateController,
                decoration: const InputDecoration(
                  labelText: AppStrings.sessionDate,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.startTime,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _endTimeController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.endTime,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                  labelText: AppStrings.room,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: AppStrings.note,
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
