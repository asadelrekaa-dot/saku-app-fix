import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/laravel_api_service.dart';
import 'dashboard_models.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc()
      : super(TransactionState(
          transactions: initialTransactions,
        )) {
    on<TransactionAdded>(_onAdded);
    on<TransactionDeleted>(_onDeleted);
    on<TransactionSettled>(_onSettled);
    on<TransactionUpdated>(_onUpdated);
  }

  Future<void> _onAdded(
    TransactionAdded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(
      state.copyWith(
        transactions: [event.item, ...state.transactions],
      ),
    );
    await _syncTransactionToApi(event.item, emit);
  }

  Future<void> _onDeleted(
    TransactionDeleted event,
    Emitter<TransactionState> emit,
  ) async {
    emit(
      state.copyWith(
        transactions:
            state.transactions.where((entry) => entry != event.item).toList(),
      ),
    );
  }

  Future<void> _onSettled(
    TransactionSettled event,
    Emitter<TransactionState> emit,
  ) async {
    final updated = state.transactions
        .map((entry) =>
            entry == event.item ? entry.copyWith(settled: true) : entry)
        .toList();
    emit(state.copyWith(transactions: updated));
    try {
      await LaravelApiService.instance.markSettled(
        apiId: event.item.apiId,
        apiType: event.item.apiType,
      );
    } catch (_) {
      // Keep local state when API is unavailable.
    }
  }

  Future<void> _onUpdated(
    TransactionUpdated event,
    Emitter<TransactionState> emit,
  ) async {
    final updated = state.transactions
        .map((entry) => entry == event.oldItem ? event.newItem : entry)
        .toList();
    emit(state.copyWith(transactions: updated));
  }

  Future<void> _syncTransactionToApi(
    DashboardTransaction item,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final synced = await LaravelApiService.instance.createTransaction(
        LaravelTransactionDraft(
          title: item.title,
          note: item.note,
          amountValue: item.amountValue,
        ),
      );
      emit(
        state.copyWith(
          transactions: state.transactions
              .map(
                (entry) => entry == item
                    ? entry.copyWith(
                        apiId: synced.apiId,
                        apiType: synced.apiType,
                      )
                    : entry,
              )
              .toList(),
        ),
      );
    } catch (_) {
      // Local-first behavior when API is unreachable.
    }
  }
}
