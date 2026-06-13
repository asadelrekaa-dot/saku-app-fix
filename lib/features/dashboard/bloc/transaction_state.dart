import 'package:freezed_annotation/freezed_annotation.dart';

import 'dashboard_models.dart';

part 'transaction_state.freezed.dart';

@freezed
class TransactionState with _$TransactionState {
  const TransactionState._();

  const factory TransactionState({
    @Default(<DashboardTransaction>[]) List<DashboardTransaction> transactions,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _TransactionState;

  int get currentBalance => transactions.fold<int>(
        0,
        (balance, item) => balance + item.amountValue,
      );

  int get currentExpense => transactions
      .where((item) => item.amountValue < 0)
      .fold<int>(0, (sum, item) => sum + item.amountValue.abs());
}
