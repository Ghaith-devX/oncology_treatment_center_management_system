// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineModel _$MedicineModelFromJson(Map<String, dynamic> json) =>
    MedicineModel(
      medicineId: (json['medicineId'] as num).toInt(),
      patientId: (json['patientId'] as num).toInt(),
      tradeName: json['tradeName'] as String?,
      activeIngredient: json['activeIngredient'] as String?,
      therapyType: json['therapyType'] as String?,
      route: json['route'] as String?,
      cycleNumber: (json['cycleNumber'] as num?)?.toInt(),
      dayNumber: (json['dayNumber'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      prescribedDose: (json['prescribedDose'] as num?)?.toDouble(),
      actualDose: (json['actualDose'] as num?)?.toDouble(),
      doseUnit: json['doseUnit'] as String?,
      dailyDose: (json['dailyDose'] as num?)?.toDouble(),
      form: json['form'] as String?,
      bsaValue: (json['bsaValue'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
      atc: json['atc'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$MedicineModelToJson(MedicineModel instance) =>
    <String, dynamic>{
      'medicineId': instance.medicineId,
      'patientId': instance.patientId,
      'tradeName': instance.tradeName,
      'activeIngredient': instance.activeIngredient,
      'therapyType': instance.therapyType,
      'route': instance.route,
      'cycleNumber': instance.cycleNumber,
      'dayNumber': instance.dayNumber,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'prescribedDose': instance.prescribedDose,
      'actualDose': instance.actualDose,
      'doseUnit': instance.doseUnit,
      'dailyDose': instance.dailyDose,
      'form': instance.form,
      'bsaValue': instance.bsaValue,
      'reason': instance.reason,
      'atc': instance.atc,
      'note': instance.note,
    };
