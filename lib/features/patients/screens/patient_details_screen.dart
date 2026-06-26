import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../controller/patients_controller.dart';

class PatientDetailsScreen extends ConsumerStatefulWidget {
  final int patientId;

  const PatientDetailsScreen({super.key, required this.patientId});

  @override
  ConsumerState<PatientDetailsScreen> createState() =>
      _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends ConsumerState<PatientDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(patientsControllerProvider.notifier)
          .loadById(widget.patientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patientsControllerProvider);
    final patient = state.selectedPatient;

    return Scaffold(
      appBar: AppBar(
        title: Text(patient?.fullName ?? AppStrings.patientDetails),
      ),
      body: switch (state.status) {
        PatientsStatus.initial || PatientsStatus.loading => const LoadingView(),
        PatientsStatus.error => ErrorView(
            message: state.error ?? AppStrings.errorOccurred,
            onRetry: () =>
                ref.read(patientsControllerProvider.notifier).loadById(widget.patientId),
          ),
        PatientsStatus.loaded => patient == null
            ? const ErrorView(message: AppStrings.noData)
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _DetailRow(label: AppStrings.fullName, value: patient.fullName),
                  _DetailRow(label: AppStrings.age, value: patient.age.toString()),
                  _DetailRow(label: AppStrings.gender, value: patient.gender ?? '--'),
                  _DetailRow(label: AppStrings.phone, value: patient.phone ?? '--'),
                  _DetailRow(label: AppStrings.address, value: patient.address ?? '--'),
                  _DetailRow(label: AppStrings.identityNumber, value: patient.identityNumber ?? '--'),
                  _DetailRow(label: AppStrings.diagnosis, value: patient.diagnosis ?? '--'),
                  _DetailRow(label: AppStrings.note, value: patient.note ?? '--'),
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
