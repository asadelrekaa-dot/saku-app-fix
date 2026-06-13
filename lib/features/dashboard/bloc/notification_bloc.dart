import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<NotificationLoaded>(_onLoaded);
    on<NotificationAdded>(_onAdded);
    on<NotificationAllRead>(_onAllRead);
  }

  void _onLoaded(NotificationLoaded event, Emitter<NotificationState> emit) {
    emit(state.copyWith(notifications: const []));
  }

  void _onAdded(NotificationAdded event, Emitter<NotificationState> emit) {
    final updated = [event.message, ...state.notifications];
    emit(state.copyWith(
      notifications: updated,
      unreadCount: updated.length,
    ));
  }

  void _onAllRead(NotificationAllRead event, Emitter<NotificationState> emit) {
    emit(state.copyWith(unreadCount: 0));
  }
}
