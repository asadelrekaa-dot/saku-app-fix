import 'package:freezed_annotation/freezed_annotation.dart';

import 'dashboard_models.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const DashboardState._();

  const factory DashboardState({
    required int currentIndex,
    required DashboardSurface surface,
    DashboardTransaction? editingTransaction,
    required List<DashboardTransaction> transactions,
    required List<DashboardBudget> budgets,

  }) = _DashboardState;

  factory DashboardState.initial({bool openAddNote = false}) {
    return DashboardState(
      currentIndex: 0,
      surface:
          openAddNote ? DashboardSurface.addExpense : DashboardSurface.main,
      transactions: initialTransactions,
      budgets: initialBudgets,
    );
  }

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
