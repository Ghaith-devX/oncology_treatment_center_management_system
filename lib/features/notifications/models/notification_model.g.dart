// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      notificationId: (json['notificationId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'userId': instance.userId,
      'title': instance.title,
      'message': instance.message,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt,
    };
