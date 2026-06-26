import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final int notificationId;
  final int userId;
  final String? title;
  final String? message;
  final bool isRead;
  final String? createdAt;

  const NotificationModel({
    required this.notificationId,
    required this.userId,
    this.title,
    this.message,
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
