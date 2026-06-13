import 'package:freezed_annotation/freezed_annotation.dart';

import 'dashboard_models.dart';

part 'dashboard_event.freezed.dart';

@freezed
class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.started() = DashboardStarted;
  const factory DashboardEvent.mainShown() = DashboardMainShown;
  const factory DashboardEvent.surfaceShown(DashboardSurface surface) =
      DashboardSurfaceShown;
  const factory DashboardEvent.addNoteShown({
    @Default(AddNoteMode.expense) AddNoteMode mode,
  }) = DashboardAddNoteShown;
  const factory DashboardEvent.tabSelected(int index) = DashboardTabSelected;
  const factory DashboardEvent.transactionAdded(DashboardTransaction item) =
      DashboardTransactionAdded;
  const factory DashboardEvent.budgetAdded(DashboardBudget item) =
      DashboardBudgetAdded;
  const factory DashboardEvent.budgetDeleted(DashboardBudget item) =
      DashboardBudgetDeleted;
  const factory DashboardEvent.transactionDeleted(DashboardTransaction item) =
      DashboardTransactionDeleted;
  const factory DashboardEvent.transactionSettled(DashboardTransaction item) =
      DashboardTransactionSettled;
  const factory DashboardEvent.editTransactionOpened(
      DashboardTransaction item) = DashboardEditTransactionOpened;
  const factory DashboardEvent.transactionUpdated({
    required DashboardTransaction oldItem,
    required DashboardTransaction newItem,
  }) = DashboardTransactionUpdated;
}
