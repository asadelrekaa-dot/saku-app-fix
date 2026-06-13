import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_event.freezed.dart';

@freezed
class NotificationEvent with _$NotificationEvent {
  const factory NotificationEvent.loaded() = NotificationLoaded;
  const factory NotificationEvent.added(String message) = NotificationAdded;
  const factory NotificationEvent.markAllRead() = NotificationAllRead;
}
