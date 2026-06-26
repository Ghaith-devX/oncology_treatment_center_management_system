// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      employeeId: (json['employeeId'] as num).toInt(),
      fullName: json['fullName'] as String,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      nationalId: json['nationalId'] as String?,
      position: json['position'] as String?,
      department: json['department'] as String?,
      hireDate: json['hireDate'] as String?,
      salary: (json['salary'] as num?)?.toDouble(),
      qualification: json['qualification'] as String?,
      status: json['status'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'fullName': instance.fullName,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'nationalId': instance.nationalId,
      'position': instance.position,
      'department': instance.department,
      'hireDate': instance.hireDate,
      'salary': instance.salary,
      'qualification': instance.qualification,
      'status': instance.status,
      'note': instance.note,
    };
