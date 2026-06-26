// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientModel _$PatientModelFromJson(Map<String, dynamic> json) => PatientModel(
  patientId: (json['patientId'] as num).toInt(),
  fullName: json['fullName'] as String,
  age: (json['age'] as num).toInt(),
  gender: json['gender'] as String?,
  address: json['address'] as String?,
  diagnosis: json['diagnosis'] as String?,
  phone: json['phone'] as String?,
  identityNumber: json['identityNumber'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$PatientModelToJson(PatientModel instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'fullName': instance.fullName,
      'age': instance.age,
      'gender': instance.gender,
      'address': instance.address,
      'diagnosis': instance.diagnosis,
      'phone': instance.phone,
      'identityNumber': instance.identityNumber,
      'note': instance.note,
    };
