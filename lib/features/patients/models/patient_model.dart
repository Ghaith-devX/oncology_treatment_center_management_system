import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

@JsonSerializable()
class PatientModel {
  final int patientId;
  final String fullName;
  final int age;
  final String? gender;
  final String? address;
  final String? diagnosis;
  final String? phone;
  final String? identityNumber;
  final String? note;

  const PatientModel({
    required this.patientId,
    required this.fullName,
    required this.age,
    this.gender,
    this.address,
    this.diagnosis,
    this.phone,
    this.identityNumber,
    this.note,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatientModelToJson(this);
}
