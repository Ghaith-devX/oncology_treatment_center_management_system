// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabModel _$LabModelFromJson(Map<String, dynamic> json) => LabModel(
  labId: (json['labId'] as num).toInt(),
  patientId: (json['patientId'] as num).toInt(),
  testDate: json['testDate'] as String?,
  testType: json['testType'] as String?,
  hemoglobin: (json['hemoglobin'] as num?)?.toDouble(),
  wbc: (json['wbc'] as num?)?.toDouble(),
  neutrophils: (json['neutrophils'] as num?)?.toDouble(),
  platelets: (json['platelets'] as num?)?.toDouble(),
  creatinine: (json['creatinine'] as num?)?.toDouble(),
  urea: (json['urea'] as num?)?.toDouble(),
  alt: (json['alt'] as num?)?.toDouble(),
  ast: (json['ast'] as num?)?.toDouble(),
  bilirubin: (json['bilirubin'] as num?)?.toDouble(),
  sodium: (json['sodium'] as num?)?.toDouble(),
  potassium: (json['potassium'] as num?)?.toDouble(),
  calcium: (json['calcium'] as num?)?.toDouble(),
  tumorMarker: json['tumorMarker'] as String?,
  resultNote: json['resultNote'] as String?,
);

Map<String, dynamic> _$LabModelToJson(LabModel instance) => <String, dynamic>{
  'labId': instance.labId,
  'patientId': instance.patientId,
  'testDate': instance.testDate,
  'testType': instance.testType,
  'hemoglobin': instance.hemoglobin,
  'wbc': instance.wbc,
  'neutrophils': instance.neutrophils,
  'platelets': instance.platelets,
  'creatinine': instance.creatinine,
  'urea': instance.urea,
  'alt': instance.alt,
  'ast': instance.ast,
  'bilirubin': instance.bilirubin,
  'sodium': instance.sodium,
  'potassium': instance.potassium,
  'calcium': instance.calcium,
  'tumorMarker': instance.tumorMarker,
  'resultNote': instance.resultNote,
};
