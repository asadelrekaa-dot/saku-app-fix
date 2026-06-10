part of 'dashboard_bloc.dart';

@freezed
class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.started() = _DashboardStarted;

  const factory DashboardEvent.mainShown() = _DashboardMainShown;

  const factory DashboardEvent.surfaceShown(DashboardSurface surface) =
      _DashboardSurfaceShown;

  const factory DashboardEvent.addNoteShown(
      [@Default(AddNoteMode.expense) AddNoteMode mode]) = _DashboardAddNoteShown;

  const factory DashboardEvent.tabSelected(int index) = _DashboardTabSelected;

  const factory DashboardEvent.transactionAdded(
    DashboardTransaction item,
  ) = _DashboardTransactionAdded;

  const factory DashboardEvent.budgetAdded(DashboardBudget item) =
      _DashboardBudgetAdded;

  const factory DashboardEvent.transactionDeleted(
    DashboardTransaction item,
  ) = _DashboardTransactionDeleted;

  const factory DashboardEvent.transactionSettled(
    DashboardTransaction item,
  ) = _DashboardTransactionSettled;

  const factory DashboardEvent.editTransactionOpened(
    DashboardTransaction item,
  ) = _DashboardEditTransactionOpened;

  const factory DashboardEvent.transactionUpdated({
    required DashboardTransaction oldItem,
    required DashboardTransaction newItem,
  }) = _DashboardTransactionUpdated;
}
