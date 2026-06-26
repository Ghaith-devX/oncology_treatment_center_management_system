import 'package:json_annotation/json_annotation.dart';

part 'lab_model.g.dart';

@JsonSerializable()
class LabModel {
  final int labId;
  final int patientId;
  final String? testDate;
  final String? testType;
  final double? hemoglobin;
  final double? wbc;
  final double? neutrophils;
  final double? platelets;
  final double? creatinine;
  final double? urea;
  final double? alt;
  final double? ast;
  final double? bilirubin;
  final double? sodium;
  final double? potassium;
  final double? calcium;
  final String? tumorMarker;
  final String? resultNote;

  const LabModel({
    required this.labId,
    required this.patientId,
    this.testDate,
    this.testType,
    this.hemoglobin,
    this.wbc,
    this.neutrophils,
    this.platelets,
    this.creatinine,
    this.urea,
    this.alt,
    this.ast,
    this.bilirubin,
    this.sodium,
    this.potassium,
    this.calcium,
    this.tumorMarker,
    this.resultNote,
  });

  factory LabModel.fromJson(Map<String, dynamic> json) =>
      _$LabModelFromJson(json);

  Map<String, dynamic> toJson() => _$LabModelToJson(this);
}
