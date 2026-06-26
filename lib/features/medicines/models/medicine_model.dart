import 'package:json_annotation/json_annotation.dart';

part 'medicine_model.g.dart';

@JsonSerializable()
class MedicineModel {
  final int medicineId;
  final int patientId;
  final String? tradeName;
  final String? activeIngredient;
  final String? therapyType;
  final String? route;
  final int? cycleNumber;
  final int? dayNumber;
  final String? startDate;
  final String? endDate;
  final double? prescribedDose;
  final double? actualDose;
  final String? doseUnit;
  final double? dailyDose;
  final String? form;
  final double? bsaValue;
  final String? reason;
  final String? atc;
  final String? note;

  const MedicineModel({
    required this.medicineId,
    required this.patientId,
    this.tradeName,
    this.activeIngredient,
    this.therapyType,
    this.route,
    this.cycleNumber,
    this.dayNumber,
    this.startDate,
    this.endDate,
    this.prescribedDose,
    this.actualDose,
    this.doseUnit,
    this.dailyDose,
    this.form,
    this.bsaValue,
    this.reason,
    this.atc,
    this.note,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineModelToJson(this);
}
