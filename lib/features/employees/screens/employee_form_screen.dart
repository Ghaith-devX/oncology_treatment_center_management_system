import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/utils/validators.dart';
import '../controller/employees_controller.dart';
import '../models/employee_model.dart';

class EmployeeFormScreen extends ConsumerStatefulWidget {
  final EmployeeModel? employee;

  const EmployeeFormScreen({super.key, this.employee});

  @override
  ConsumerState<EmployeeFormScreen> createState() =>
      _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends ConsumerState<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _positionController;
  late final TextEditingController _departmentController;
  late final TextEditingController _salaryController;
  late final TextEditingController _qualificationController;
  late final TextEditingController _noteController;
  String? _gender;
  String? _status;

  bool get isEdit => widget.employee != null;

  @override
  void initState() {
    super.initState();
    final e = widget.employee;
    _nameController = TextEditingController(text: e?.fullName ?? '');
    _phoneController = TextEditingController(text: e?.phone ?? '');
    _emailController = TextEditingController(text: e?.email ?? '');
    _addressController = TextEditingController(text: e?.address ?? '');
    _nationalIdController = TextEditingController(text: e?.nationalId ?? '');
    _positionController = TextEditingController(text: e?.position ?? '');
    _departmentController = TextEditingController(text: e?.department ?? '');
    _salaryController = TextEditingController(
      text: e?.salary?.toString() ?? '',
    );
    _qualificationController = TextEditingController(
      text: e?.qualification ?? '',
    );
    _noteController = TextEditingController(text: e?.note ?? '');
    _gender = e?.gender;
    _status = e?.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _nationalIdController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    _salaryController.dispose();
    _qualificationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final employee = EmployeeModel(
      employeeId: widget.employee?.employeeId ?? 0,
      fullName: _nameController.text.trim(),
      gender: _gender,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
      position: _positionController.text.trim(),
      department: _departmentController.text.trim(),
      salary: double.tryParse(_salaryController.text.trim()),
      qualification: _qualificationController.text.trim(),
      status: _status,
      note: _noteController.text.trim(),
    );

    final controller = ref.read(employeesControllerProvider.notifier);
    String? error;

    if (isEdit) {
      error = await controller.update(widget.employee!.employeeId, employee);
    } else {
      error = await controller.create(employee);
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
    final state = ref.watch(employeesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? AppStrings.editEmployee : AppStrings.addEmployee),
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
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: AppStrings.email,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nationalIdController,
                decoration: const InputDecoration(
                  labelText: AppStrings.nationalId,
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
                controller: _positionController,
                decoration: const InputDecoration(
                  labelText: AppStrings.position,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: AppStrings.department,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: AppStrings.salary,
                ),
                validator: Validators.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qualificationController,
                decoration: const InputDecoration(
                  labelText: AppStrings.qualification,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: AppStrings.status,
                ),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text(AppStrings.active)),
                  DropdownMenuItem(
                    value: 'inactive',
                    child: Text(AppStrings.inactive),
                  ),
                ],
                onChanged: (v) => setState(() => _status = v),
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
