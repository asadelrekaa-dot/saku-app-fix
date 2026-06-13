import 'package:freezed_annotation/freezed_annotation.dart';

import 'dashboard_models.dart';

part 'transaction_event.freezed.dart';

@freezed
class TransactionEvent with _$TransactionEvent {
  const factory TransactionEvent.added(DashboardTransaction item) =
      TransactionAdded;
  const factory TransactionEvent.deleted(DashboardTransaction item) =
      TransactionDeleted;
  const factory TransactionEvent.settled(DashboardTransaction item) =
      TransactionSettled;
  const factory TransactionEvent.updated({
    required DashboardTransaction oldItem,
    required DashboardTransaction newItem,
  }) = TransactionUpdated;
  const factory TransactionEvent.editOpened(DashboardTransaction item) =
      TransactionEditOpened;
}
