import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../controller/patients_controller.dart';
import '../widgets/patient_card.dart';
import '../widgets/patient_search_bar.dart';
import 'patient_details_screen.dart';
import 'patient_form_screen.dart';

class PatientsListScreen extends ConsumerStatefulWidget {
  const PatientsListScreen({super.key});

  @override
  ConsumerState<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends ConsumerState<PatientsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(patientsControllerProvider.notifier).loadAll();
    });
  }

  void _navigateToDetails(int patientId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PatientDetailsScreen(patientId: patientId),
      ),
    );
  }

  void _navigateToForm() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PatientFormScreen()),
    );
  }

  void _confirmDelete(int id, String name) {
    ConfirmDialog.show(
      context,
      title: AppStrings.confirmDelete,
      message: '${AppStrings.confirmDelete} $name؟',
      onConfirm: () async {
        final error = await ref.read(patientsControllerProvider.notifier).delete(id);
        if (error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: AppColors.danger),
          );
        } else if (!mounted) {
          return;
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
    final state = ref.watch(patientsControllerProvider);
    final controller = ref.read(patientsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.patients),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToForm,
          ),
        ],
      ),
      body: switch (state.status) {
        PatientsStatus.initial || PatientsStatus.loading => const LoadingView(),
        PatientsStatus.error => ErrorView(
            message: state.error ?? AppStrings.errorOccurred,
            onRetry: () => controller.loadAll(),
          ),
        PatientsStatus.loaded => Column(
            children: [
              PatientSearchBar(
                query: state.searchQuery,
                onChanged: controller.setSearchQuery,
              ),
              Expanded(
                child: state.filteredPatients.isEmpty
                    ? EmptyStateView(
                        message: state.searchQuery.isEmpty
                            ? AppStrings.noPatients
                            : '${AppStrings.noPatients} (${AppStrings.search})',
                        actionLabel: AppStrings.addFirstPatient,
                        onAction: _navigateToForm,
                        icon: Icons.person_add_outlined,
                      )
                    : RefreshIndicator(
                        onRefresh: () => controller.loadAll(),
                        child: ListView.builder(
                          itemCount: state.filteredPatients.length,
                          itemBuilder: (_, i) {
                            final patient = state.filteredPatients[i];
                            return PatientCard(
                              patient: patient,
                              onTap: () => _navigateToDetails(patient.patientId),
                              onDelete: () =>
                                  _confirmDelete(patient.patientId, patient.fullName),
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
