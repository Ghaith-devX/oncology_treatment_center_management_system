import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  final int employeeId;
  final String fullName;
  final String? gender;
  final String? birthDate;
  final String? phone;
  final String? email;
  final String? address;
  final String? nationalId;
  final String? position;
  final String? department;
  final String? hireDate;
  final double? salary;
  final String? qualification;
  final String? status;
  final String? note;

  const EmployeeModel({
    required this.employeeId,
    required this.fullName,
    this.gender,
    this.birthDate,
    this.phone,
    this.email,
    this.address,
    this.nationalId,
    this.position,
    this.department,
    this.hireDate,
    this.salary,
    this.qualification,
    this.status,
    this.note,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}
