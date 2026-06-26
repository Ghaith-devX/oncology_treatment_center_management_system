import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/utils/validators.dart';
import '../controller/patients_controller.dart';
import '../models/patient_model.dart';

class PatientFormScreen extends ConsumerStatefulWidget {
  final PatientModel? patient;

  const PatientFormScreen({super.key, this.patient});

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _identityNumberController;
  late final TextEditingController _noteController;
  String? _gender;

  bool get isEdit => widget.patient != null;

  @override
  void initState() {
    super.initState();
    final p = widget.patient;
    _nameController = TextEditingController(text: p?.fullName ?? '');
    _ageController = TextEditingController(text: p?.age.toString() ?? '');
    _phoneController = TextEditingController(text: p?.phone ?? '');
    _addressController = TextEditingController(text: p?.address ?? '');
    _diagnosisController = TextEditingController(text: p?.diagnosis ?? '');
    _identityNumberController = TextEditingController(text: p?.identityNumber ?? '');
    _noteController = TextEditingController(text: p?.note ?? '');
    _gender = p?.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _diagnosisController.dispose();
    _identityNumberController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final patient = PatientModel(
      patientId: widget.patient?.patientId ?? 0,
      fullName: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 0,
      gender: _gender,
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      diagnosis: _diagnosisController.text.trim(),
      identityNumber: _identityNumberController.text.trim(),
      note: _noteController.text.trim(),
    );

    final controller = ref.read(patientsControllerProvider.notifier);
    String? error;

    if (isEdit) {
      error = await controller.update(widget.patient!.patientId, patient);
    } else {
      error = await controller.create(patient);
    }

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
    final state = ref.watch(patientsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? AppStrings.editPatient : AppStrings.addPatient),
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
                validator: Validators.required,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: AppStrings.age,
                ),
                validator: Validators.positiveNumber,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: const InputDecoration(
                  labelText: AppStrings.gender,
                ),
                items: const [
                  DropdownMenuItem(value: 'ذكر', child: Text(AppStrings.male)),
                  DropdownMenuItem(value: 'أنثى', child: Text(AppStrings.female)),
                ],
                onChanged: (v) => setState(() => _gender = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: AppStrings.phone,
                ),
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _identityNumberController,
                decoration: const InputDecoration(
                  labelText: AppStrings.identityNumber,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: AppStrings.address,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diagnosisController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: AppStrings.diagnosis,
                ),
              ),
              const SizedBox(height: 16),
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
