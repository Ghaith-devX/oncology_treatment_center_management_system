import 'package:json_annotation/json_annotation.dart';

part 'treatment_session_model.g.dart';

@JsonSerializable()
class TreatmentSessionModel {
  final int sessionId;
  final int patientId;
  final int? doctorId;
  final int? nurseId;
  final String? sessionType;
  final String? sessionDate;
  final String? startTime;
  final String? endTime;
  final int? cycleNumber;
  final int? sessionNumber;
  final String? protocolId;
  final String? medicationList;
  final String? vitalSigns;
  final String? preMedications;
  final String? complications;
  final String? status;
  final String? room;
  final String? nextSessionDate;
  final String? note;

  const TreatmentSessionModel({
    required this.sessionId,
    required this.patientId,
    this.doctorId,
    this.nurseId,
    this.sessionType,
    this.sessionDate,
    this.startTime,
    this.endTime,
    this.cycleNumber,
    this.sessionNumber,
    this.protocolId,
    this.medicationList,
    this.vitalSigns,
    this.preMedications,
    this.complications,
    this.status,
    this.room,
    this.nextSessionDate,
    this.note,
  });

  factory TreatmentSessionModel.fromJson(Map<String, dynamic> json) =>
      _$TreatmentSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TreatmentSessionModelToJson(this);
}
