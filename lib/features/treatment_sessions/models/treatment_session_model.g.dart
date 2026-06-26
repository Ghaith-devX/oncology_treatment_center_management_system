// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreatmentSessionModel _$TreatmentSessionModelFromJson(
  Map<String, dynamic> json,
) => TreatmentSessionModel(
  sessionId: (json['sessionId'] as num).toInt(),
  patientId: (json['patientId'] as num).toInt(),
  doctorId: (json['doctorId'] as num?)?.toInt(),
  nurseId: (json['nurseId'] as num?)?.toInt(),
  sessionType: json['sessionType'] as String?,
  sessionDate: json['sessionDate'] as String?,
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
  cycleNumber: (json['cycleNumber'] as num?)?.toInt(),
  sessionNumber: (json['sessionNumber'] as num?)?.toInt(),
  protocolId: json['protocolId'] as String?,
  medicationList: json['medicationList'] as String?,
  vitalSigns: json['vitalSigns'] as String?,
  preMedications: json['preMedications'] as String?,
  complications: json['complications'] as String?,
  status: json['status'] as String?,
  room: json['room'] as String?,
  nextSessionDate: json['nextSessionDate'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$TreatmentSessionModelToJson(
  TreatmentSessionModel instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'patientId': instance.patientId,
  'doctorId': instance.doctorId,
  'nurseId': instance.nurseId,
  'sessionType': instance.sessionType,
  'sessionDate': instance.sessionDate,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'cycleNumber': instance.cycleNumber,
  'sessionNumber': instance.sessionNumber,
  'protocolId': instance.protocolId,
  'medicationList': instance.medicationList,
  'vitalSigns': instance.vitalSigns,
  'preMedications': instance.preMedications,
  'complications': instance.complications,
  'status': instance.status,
  'room': instance.room,
  'nextSessionDate': instance.nextSessionDate,
  'note': instance.note,
};
