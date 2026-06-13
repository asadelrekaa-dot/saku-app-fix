import 'package:freezed_annotation/freezed_annotation.dart';

import 'dashboard_models.dart';

part 'budget_state.freezed.dart';

@freezed
class BudgetState with _$BudgetState {
  const BudgetState._();

  const factory BudgetState({
    @Default(<DashboardBudget>[]) List<DashboardBudget> budgets,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _BudgetState;
}
