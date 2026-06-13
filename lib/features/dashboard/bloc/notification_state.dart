import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  const NotificationState._();

  const factory NotificationState({
    @Default(<String>[]) List<String> notifications,
    @Default(false) bool isLoading,
    @Default(0) int unreadCount,
    String? errorMessage,
  }) = _NotificationState;
}
