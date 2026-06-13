import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../core/models/dashboard_models.dart';
import '../../../../core/repository/local_repository.dart';
import '../../../../core/repository/transaction_repository.dart';
import '../../../../core/utils/format_utils.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_bloc.freezed.dart';

enum DashboardSurface {
  main,
  budget,
  insight,
  notifications,
  addExpense,
  addIncome,
  addDebt,
  addLoan,
  editTransaction,
}

enum AddNoteMode { expense, income, debt, loan }

DashboardSurface surfaceForMode(AddNoteMode mode) {
  return switch (mode) {
    AddNoteMode.expense => DashboardSurface.addExpense,
    AddNoteMode.income => DashboardSurface.addIncome,
    AddNoteMode.debt => DashboardSurface.addDebt,
    AddNoteMode.loan => DashboardSurface.addLoan,
  };
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    bool openAddNote = false,
    ITransactionRepository transactionRepository = const ApiTransactionRepository(),
    LocalRepository localRepository = const LocalRepository(),
  })  : _transactionRepository = transactionRepository,
        _localRepository = localRepository,
        super(DashboardState(
          surface:
              openAddNote ? DashboardSurface.addExpense : DashboardSurface.main,
        )) {
    on<_DashboardStarted>(_onStarted);
    on<_DashboardMainShown>(_onMainShown);
    on<_DashboardSurfaceShown>(_onSurfaceShown);
    on<_DashboardAddNoteShown>(_onAddNoteShown);
    on<_DashboardTabSelected>(_onTabSelected);
    on<_DashboardTransactionAdded>(_onTransactionAdded);
    on<_DashboardBudgetAdded>(_onBudgetAdded);
    on<_DashboardTransactionDeleted>(_onTransactionDeleted);
    on<_DashboardTransactionSettled>(_onTransactionSettled);
    on<_DashboardEditTransactionOpened>(_onEditTransactionOpened);
    on<_DashboardTransactionUpdated>(_onTransactionUpdated);
  }

  final ITransactionRepository _transactionRepository;
  final LocalRepository _localRepository;

  static const _homeWidgetProvider = 'SakuSummaryWidgetProvider';

  Future<void> _onStarted(
    _DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    final results = await Future.wait([
      _localRepository.loadTransactions(),
      _localRepository.loadBudgets(),
    ]);
    emit(state.copyWith(
      transactions: results[0] as List<DashboardTransaction>,
      budgets: results[1] as List<DashboardBudget>,
    ));
    await _syncHomeWidget();
  }

  void _onMainShown(
    _DashboardMainShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(surface: DashboardSurface.main, errorMessage: null));
  }

  void _onSurfaceShown(
    _DashboardSurfaceShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(surface: event.surface, errorMessage: null));
  }

  void _onAddNoteShown(
    _DashboardAddNoteShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(surface: surfaceForMode(event.mode), errorMessage: null));
  }

  void _onTabSelected(
    _DashboardTabSelected event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index, errorMessage: null));
  }

  Future<void> _onTransactionAdded(
    _DashboardTransactionAdded event,
    Emitter<DashboardState> emit,
  ) async {
    await _localRepository.saveTransaction(event.item);
    emit(state.copyWith(
      transactions: [event.item, ...state.transactions],
      surface: DashboardSurface.main,
      currentIndex: 1,
      isLoading: true,
    ));
    await _syncHomeWidget();
    try {
      final result = await _transactionRepository.createTransaction(
        title: event.item.title,
        note: event.item.note,
        amountValue: event.item.amountValue,
      );
      if (result != null) {
        final updated = state.transactions
            .map((entry) =>
                entry == event.item
                    ? entry.copyWith(apiId: result.apiId, apiType: result.apiType)
                    : entry)
            .toList();
        await _localRepository.deleteTransaction(event.item);
        await _localRepository.saveTransaction(
          event.item.copyWith(apiId: result.apiId, apiType: result.apiType),
        );
        emit(state.copyWith(transactions: updated, isLoading: false));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal menyinkronkan transaksi ke server',
        ));
      }
    } catch (e, s) {
      log('[DashboardBloc] _onTransactionAdded sync error', error: e, stackTrace: s);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal menyinkronkan transaksi ke server',
      ));
    }
  }

  Future<void> _onBudgetAdded(
    _DashboardBudgetAdded event,
    Emitter<DashboardState> emit,
  ) async {
    await _localRepository.saveBudget(event.item);
    emit(state.copyWith(budgets: [event.item, ...state.budgets], errorMessage: null));
  }

  Future<void> _onTransactionDeleted(
    _DashboardTransactionDeleted event,
    Emitter<DashboardState> emit,
  ) async {
    await _localRepository.deleteTransaction(event.item);
    emit(state.copyWith(
      transactions:
          state.transactions.where((entry) => entry != event.item).toList(),
      isLoading: true,
      errorMessage: null,
    ));
    await _syncHomeWidget();
    try {
      final apiId = event.item.apiId;
      final apiType = event.item.apiType;
      if (apiId != null && apiType != null) {
        await _transactionRepository.deleteTransaction(
          apiId: apiId,
          apiType: apiType,
        );
      }
    } catch (e, s) {
      log('[DashboardBloc] _onTransactionDeleted sync error', error: e, stackTrace: s);
    }
    emit(state.copyWith(isLoading: false, errorMessage: null));
  }

  Future<void> _onTransactionSettled(
    _DashboardTransactionSettled event,
    Emitter<DashboardState> emit,
  ) async {
    final settledItem = event.item.copyWith(settled: true);
    await _localRepository.deleteTransaction(event.item);
    await _localRepository.saveTransaction(settledItem);
    final updated = state.transactions
        .map((entry) =>
            entry == event.item ? entry.copyWith(settled: true) : entry)
        .toList();
    emit(state.copyWith(transactions: updated, isLoading: true, errorMessage: null));
    await _syncHomeWidget();
    try {
      final apiId = event.item.apiId;
      final apiType = event.item.apiType;
      if (apiId != null && apiType != null) {
        await _transactionRepository.markSettled(
          apiId: apiId,
          apiType: apiType,
        );
      }
    } catch (e, s) {
      log('[DashboardBloc] _onTransactionSettled sync error', error: e, stackTrace: s);
    }
    emit(state.copyWith(isLoading: false, errorMessage: null));
  }

  void _onEditTransactionOpened(
    _DashboardEditTransactionOpened event,
    Emitter<DashboardState> emit,
  ) {
    emit(
      state.copyWith(
        editingTransaction: event.item,
        surface: DashboardSurface.editTransaction,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onTransactionUpdated(
    _DashboardTransactionUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    await _localRepository.deleteTransaction(event.oldItem);
    await _localRepository.saveTransaction(event.newItem);
    final updated = state.transactions
        .map((entry) => entry == event.oldItem ? event.newItem : entry)
        .toList();
    emit(state.copyWith(
      transactions: updated,
      editingTransaction: null,
      surface: DashboardSurface.main,
      currentIndex: 1,
      isLoading: true,
      errorMessage: null,
    ));
    await _syncHomeWidget();
    try {
      final apiId = event.oldItem.apiId ?? event.newItem.apiId;
      final apiType = event.oldItem.apiType ?? event.newItem.apiType;
      if (apiId != null && apiType != null) {
        await _transactionRepository.updateTransaction(
          apiId: apiId,
          apiType: apiType,
          title: event.newItem.title,
          note: event.newItem.note,
          amountValue: event.newItem.amountValue,
        );
      }
    } catch (e, s) {
      log('[DashboardBloc] _onTransactionUpdated sync error', error: e, stackTrace: s);
    }
    emit(state.copyWith(isLoading: false, errorMessage: null));
  }

  Future<void> _syncHomeWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'balance',
        'Rp ${formatPlain(state.currentBalance)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'expense',
        'Rp ${formatPlain(state.currentExpense)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'latest',
        state.transactions.isEmpty
            ? 'Belum ada catatan'
            : '${state.transactions.first.title} ${state.transactions.first.amount}',
      );
      await HomeWidget.updateWidget(name: _homeWidgetProvider);
    } catch (e, s) {
      log('[DashboardBloc] _syncHomeWidget error', error: e, stackTrace: s);
    }
  }
}
