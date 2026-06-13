import 'package:freezed_annotation/freezed_annotation.dart';

import 'dashboard_models.dart';

part 'budget_event.freezed.dart';

@freezed
class BudgetEvent with _$BudgetEvent {
  const factory BudgetEvent.loaded() = BudgetLoaded;
  const factory BudgetEvent.added(DashboardBudget item) = BudgetAdded;
  const factory BudgetEvent.deleted(DashboardBudget item) = BudgetDeleted;
}
