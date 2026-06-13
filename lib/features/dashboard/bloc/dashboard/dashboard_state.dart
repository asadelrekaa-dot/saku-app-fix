part of 'dashboard_bloc.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(0) int currentIndex,
    @Default(DashboardSurface.main) DashboardSurface surface,
    @Default(<DashboardTransaction>[]) List<DashboardTransaction> transactions,
    @Default(<DashboardBudget>[]) List<DashboardBudget> budgets,
    DashboardTransaction? editingTransaction,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _DashboardState;
}

extension DashboardStateX on DashboardState {
  int get currentBalance => transactions.fold<int>(
        0,
        (balance, item) => balance + item.amountValue,
      );

  int get currentExpense => transactions
      .where((item) => item.amountValue < 0)
      .fold<int>(0, (sum, item) => sum + item.amountValue.abs());

  bool get showBottomNavigation => surface == DashboardSurface.main;

  bool get hidesFloatingActionButton =>
      surface == DashboardSurface.insight ||
      surface == DashboardSurface.notifications ||
      surface == DashboardSurface.addExpense ||
      surface == DashboardSurface.addIncome ||
      surface == DashboardSurface.addDebt ||
      surface == DashboardSurface.addLoan ||
      surface == DashboardSurface.editTransaction;
}
