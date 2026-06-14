import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import '../../../core/api/laravel_api_service.dart';
import '../../../core/notification/notification_service.dart';
import '../../../core/repository/local_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/dashboard_shared.dart' show categoryIcon;
import 'dashboard_event.dart';
import 'dashboard_models.dart';
import 'dashboard_state.dart';

export 'budget_bloc.dart';
export 'budget_event.dart';
export 'budget_state.dart';
export 'dashboard_event.dart';
export 'dashboard_models.dart';
export 'dashboard_state.dart';
export 'notification_bloc.dart';
export 'notification_event.dart';
export 'notification_state.dart';
export 'transaction_bloc.dart';
export 'transaction_event.dart';
export 'transaction_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({bool openAddNote = false})
      : super(DashboardState.initial(openAddNote: openAddNote)) {
    on<DashboardStarted>(_onStarted);
    on<DashboardMainShown>(_onMainShown);
    on<DashboardSurfaceShown>(_onSurfaceShown);
    on<DashboardAddNoteShown>(_onAddNoteShown);
    on<DashboardTabSelected>(_onTabSelected);
    on<DashboardTransactionAdded>(_onTransactionAdded);
    on<DashboardBudgetAdded>(_onBudgetAdded);
    on<DashboardBudgetDeleted>(_onBudgetDeleted);
    on<DashboardTransactionDeleted>(_onTransactionDeleted);
    on<DashboardTransactionSettled>(_onTransactionSettled);
    on<DashboardEditTransactionOpened>(_onEditTransactionOpened);
    on<DashboardTransactionUpdated>(_onTransactionUpdated);
  }

  static const _homeWidgetProvider = 'SakuSummaryWidgetProvider';
  final _repo = const LocalRepository();
  final Set<String> _notifiedBudgetKeys = {};
  final Set<String> _notifiedSpendingKeys = {};

  Future<void> _adjustWalletBalance(int delta, {int? walletId}) async {
    try {
      final id = walletId ?? await LaravelApiService.instance.getWalletId();
      final wallets = await _repo.loadWallets();
      if (wallets.isEmpty) return;
      var found = false;
      final updated = wallets.map((w) {
        if (w.id == id) {
          found = true;
          return WalletItem(id: w.id, name: w.name, balance: w.balance + delta, icon: w.icon);
        }
        return w;
      }).toList();
      if (!found) {
        updated[0] = WalletItem(
          id: wallets[0].id,
          name: wallets[0].name,
          balance: wallets[0].balance + delta,
          icon: wallets[0].icon,
        );
      }
      await _repo.replaceAllWallets(updated);
    } catch (e) {
      log('[DashboardBloc] Failed to adjust wallet balance', error: e);
    }
  }

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    // 1. Load from local DB instantly
    final localTx = await _repo.loadTransactions();
    final localBg = await _repo.loadBudgets();
    emit(state.copyWith(transactions: localTx, budgets: localBg));
    _recalculateBudgetProgress(emit);

    // 2. Try API, fall back to local data
    await Future.wait([
      _fetchTransactions(),
      _fetchBudgets(),
    ]);
    _recalculateBudgetProgress(emit);
    await _syncHomeWidget();
    NotificationService.instance.scheduleDailyReminder();
    NotificationService.instance.scheduleAfternoonReminder();
    _checkAndNotify();
  }

  Future<void> _fetchTransactions() async {
    try {
      final list = await LaravelApiService.instance.getTransactions();
      final transactions = list.map(_parseTransaction).toList();
      await _repo.replaceAllTransactions(transactions);
      emit(state.copyWith(transactions: transactions));
    } catch (e) {
      log('[DashboardBloc] Failed to fetch transactions, using local data', error: e);
    }
  }

  Future<void> _fetchBudgets() async {
    try {
      final list = await LaravelApiService.instance.getBudgets();
      final budgets = list.map(_parseBudgetItem).toList();
      await _repo.replaceAllBudgets(budgets);
      emit(state.copyWith(budgets: budgets));
    } catch (e) {
      log('[DashboardBloc] Failed to fetch budgets, using local data', error: e);
    }
  }

  void _recalculateBudgetProgress(Emitter<DashboardState> emit) {
    final expenses = <String, int>{};
    for (final tx in state.transactions) {
      if (tx.amountValue >= 0) continue;
      final cat = tx.title;
      expenses[cat] = (expenses[cat] ?? 0) + tx.amountValue.abs();
    }

    final updated = state.budgets.map((budget) {
      final spent = expenses[budget.title] ?? 0;
      if (budget.amountValue <= 0) return budget;
      final progress = (spent / budget.amountValue).clamp(0.0, 1.0);
      final remaining = budget.amountValue - spent;
      final remainingText = remaining >= 0
          ? 'sisa Rp ${formatPlainAmount(remaining)}'
          : 'kelebihan Rp ${formatPlainAmount(-remaining)}';
      return budget.copyWith(
        remaining: remainingText,
        progress: progress,
      );
    }).toList();

    emit(state.copyWith(budgets: updated));
  }

  DashboardBudget _parseBudgetItem(Map<String, dynamic> item) {
    final kategori = (item['kategori'] ?? 'Lainnya').toString();
    return DashboardBudget(
      title: kategori,
      amountValue: (item['nominal'] ?? 0) as int,
      remaining: 'sisa Rp 0',
      progress: 0,
      icon: categoryIcon(kategori),
      apiId: (item['id'] as int?),
      walletId: (item['wallet_id'] as int?),
    );
  }

  DashboardTransaction _parseTransaction(Map<String, dynamic> item) {
    final type = (item['type'] ?? '').toString();
    final nominal = (item['nominal'] ?? 0) as int;
    final isOutcome = type == 'outcome' || type == 'hutang';
    final title = type == 'income' || type == 'outcome'
        ? (item['kategori'] ?? 'Lainnya').toString()
        : type == 'hutang'
            ? 'Hutang'
            : 'Beri Pinjaman';
    final note = (item['notes'] ?? '').toString();
    final waktu = (item['waktu'] ?? '').toString();
    final parsed = DateTime.tryParse(waktu);
    final date = parsed != null
        ? '${parsed.day} ${_monthName(parsed.month)} ${parsed.year}'
        : '—';
    final time = parsed != null
        ? '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}'
        : '—';
    final linkNote = note.isNotEmpty
        ? note
        : title == 'Hutang' || title == 'Beri Pinjaman'
            ? '${title == 'Beri Pinjaman' ? 'Pinjaman ke' : 'Hutang ke'} ${(item['nama'] ?? '').toString()}'
            : note;

    final deadlineRaw = item['deadline'] as String?;
    final deadlineParsed = deadlineRaw != null
        ? (DateTime.tryParse(deadlineRaw)?.toIso8601String())
        : null;

    return DashboardTransaction(
      title: title,
      note: linkNote,
      amountValue: isOutcome ? -nominal : nominal,
      date: date,
      time: time,
      icon: categoryIcon(title),
      color: isOutcome ? SakuColors.danger : SakuColors.success,
      apiId: (item['id'] as int?) ?? item['id']?.toString().hashCode,
      apiType: type,
      rawDate: waktu.isNotEmpty ? waktu : null,
      deadline: deadlineParsed,
    );
  }

  static const _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  String _monthName(int month) => _months[month - 1];

  void _onMainShown(
    DashboardMainShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(surface: DashboardSurface.main));
  }

  void _onSurfaceShown(
    DashboardSurfaceShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(surface: event.surface));
  }

  void _onAddNoteShown(
    DashboardAddNoteShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(surface: surfaceForMode(event.mode)));
  }

  void _onTabSelected(
    DashboardTabSelected event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }

  Future<void> _onTransactionAdded(
    DashboardTransactionAdded event,
    Emitter<DashboardState> emit,
  ) async {
    await _adjustWalletBalance(event.item.amountValue);

    emit(
      state.copyWith(
        transactions: [event.item, ...state.transactions],
        surface: DashboardSurface.main,
        currentIndex: 1,
      ),
    );
    _recalculateBudgetProgress(emit);
    await _syncHomeWidget();
    _checkNotifications();

    try {
      final synced = await LaravelApiService.instance.createTransaction(
        LaravelTransactionDraft(
          title: event.item.title,
          note: event.item.note,
          amountValue: event.item.amountValue,
          rawDate: event.item.rawDate,
          deadline: event.item.deadline,
        ),
      );
      final saved = event.item.copyWith(
        apiId: synced.apiId,
        apiType: synced.apiType,
      );
      emit(state.copyWith(
        transactions: [saved, ...state.transactions.sublist(1)],
      ));
      await _repo.addTransaction(saved);
    } catch (e) {
      log('[DashboardBloc] Failed to sync transaction to API', error: e);
      await _repo.addTransaction(event.item);
    }
  }

  Future<void> _onBudgetAdded(
    DashboardBudgetAdded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(budgets: [event.item, ...state.budgets]));
    _recalculateBudgetProgress(emit);
    await _syncBudgetToApi(event.item, emit);
  }

  Future<void> _syncBudgetToApi(
    DashboardBudget item,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final result = await LaravelApiService.instance.createBudget(
        kategoriId: _kategoriId(item.title),
        nominal: item.amountValue,
        walletId: item.walletId,
      );
      final apiId = result['id'] as int?;
      final walletId = result['wallet_id'] as int?;
      if (apiId != null) {
        final saved = item.copyWith(apiId: apiId, walletId: walletId ?? item.walletId);
        emit(
          state.copyWith(
            budgets: state.budgets
                .map((b) => b == item ? saved : b)
                .toList(),
          ),
        );
        await _repo.addBudget(saved);
        return;
      }
    } catch (e) {
      log('[DashboardBloc] Failed to sync budget to API', error: e);
    }
    await _repo.addBudget(item);
  }

  Future<void> _onBudgetDeleted(
    DashboardBudgetDeleted event,
    Emitter<DashboardState> emit,
  ) async {
    final remaining = state.budgets.where((b) => b != event.item).toList();
    emit(state.copyWith(budgets: remaining));
    _recalculateBudgetProgress(emit);
    await _syncHomeWidget();
    await _repo.replaceAllBudgets(remaining);

    final apiId = event.item.apiId;
    if (apiId != null) {
      try {
        await LaravelApiService.instance.deleteBudget(apiId: apiId);
      } catch (e) {
        log('[DashboardBloc] Failed to delete remote budget', error: e);
    }
    }
  }

  Future<void> _onTransactionDeleted(
    DashboardTransactionDeleted event,
    Emitter<DashboardState> emit,
  ) async {
    await _adjustWalletBalance(-event.item.amountValue);

    emit(
      state.copyWith(
        transactions:
            state.transactions.where((entry) => entry != event.item).toList(),
      ),
    );
    _recalculateBudgetProgress(emit);
    await _syncHomeWidget();
    _checkNotifications();
    await _repo.deleteTransaction(event.item);

    try {
      await LaravelApiService.instance.deleteTransaction(
        apiId: event.item.apiId,
        apiType: event.item.apiType,
      );
    } catch (e) {
      log('[DashboardBloc] Failed to delete remote transaction', error: e);
    }
  }

  Future<void> _onTransactionSettled(
    DashboardTransactionSettled event,
    Emitter<DashboardState> emit,
  ) async {
    await _adjustWalletBalance(-event.item.amountValue, walletId: event.walletId);

    final settled = event.item.copyWith(settled: true);
    final updated = state.transactions
        .map((entry) => entry == event.item ? settled : entry)
        .toList();
    emit(state.copyWith(transactions: updated));
    await _syncHomeWidget();
    await _repo.updateTransaction(event.item, settled);
    try {
      await LaravelApiService.instance.markSettled(
        apiId: event.item.apiId,
        apiType: event.item.apiType,
      );
    } catch (e) {
      log('[DashboardBloc] Failed to mark remote settled', error: e);
    }
  }

  void _onEditTransactionOpened(
    DashboardEditTransactionOpened event,
    Emitter<DashboardState> emit,
  ) {
    emit(
      state.copyWith(
        editingTransaction: event.item,
        surface: DashboardSurface.editTransaction,
      ),
    );
  }

  Future<void> _onTransactionUpdated(
    DashboardTransactionUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    await _adjustWalletBalance(event.newItem.amountValue - event.oldItem.amountValue);

    final updated = state.transactions
        .map((entry) => entry == event.oldItem ? event.newItem : entry)
        .toList();
    emit(
      state.copyWith(
        transactions: updated,
        editingTransaction: null,
        surface: DashboardSurface.main,
        currentIndex: 1,
      ),
    );
    _recalculateBudgetProgress(emit);
    await _syncHomeWidget();
    _checkNotifications();
    await _repo.updateTransaction(event.oldItem, event.newItem);

    try {
      await LaravelApiService.instance.updateTransaction(
        apiId: event.newItem.apiId ?? event.oldItem.apiId,
        apiType: event.newItem.apiType ?? event.oldItem.apiType,
        item: LaravelTransactionDraft(
          title: event.newItem.title,
          note: event.newItem.note,
          amountValue: event.newItem.amountValue,
          rawDate: event.newItem.rawDate,
          deadline: event.newItem.deadline,
        ),
      );
    } catch (e) {
      log('[DashboardBloc] Failed to update remote transaction', error: e);
    }
  }

  Future<void> _checkAndNotify() async {
    for (final budget in state.budgets) {
      if (budget.amountValue <= 0) continue;
      final thresholdCrossed = budget.progress >= 0.8;
      final key = 'budget:${budget.title}:${budget.amountValue}';
      if (thresholdCrossed) {
        if (!_notifiedBudgetKeys.contains(key)) {
          _notifiedBudgetKeys.add(key);
          final remaining =
              budget.amountValue - (budget.amountValue * budget.progress).round();
          NotificationService.instance.showBudgetLowNotification(
            budget.title,
            remaining,
            (1 - budget.progress) * 100,
          );
        }
      } else {
        _notifiedBudgetKeys.remove(key);
      }
    }

    try {
      final wallets = await _repo.loadWallets();
      final walletBalance = wallets.fold<int>(0, (sum, w) => sum + w.balance);
      if (walletBalance > 0) {
        final totalExpense = state.currentExpense;
        final spendingKey = 'spending:$walletBalance';
        if (totalExpense > walletBalance * 0.5) {
          if (!_notifiedSpendingKeys.contains(spendingKey)) {
            _notifiedSpendingKeys.add(spendingKey);
            NotificationService.instance.showHighSpendingNotification(
              totalExpense,
              walletBalance,
            );
          }
        } else {
          _notifiedSpendingKeys.remove(spendingKey);
        }
      }
    } catch (e) {
      log('[DashboardBloc] Failed to check notifications', error: e);
    }
  }

  Future<void> _checkNotifications() async {
    _checkAndNotify();
  }

  Future<void> _syncHomeWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'balance',
        'Rp ${formatPlainAmount(state.currentBalance)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'expense',
        'Rp ${formatPlainAmount(state.currentExpense)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'latest',
        state.transactions.isEmpty
            ? 'Belum ada catatan'
            : '${state.transactions.first.title} ${state.transactions.first.amount}',
      );
      await HomeWidget.updateWidget(name: _homeWidgetProvider);
    } catch (_) {
      // Platform channel is not available on web and widget tests.
    }
  }

}

int _kategoriId(String title) {
  const map = {
    'makanan': 1,
    'transportasi': 2,
    'rumah': 3,
    'kesehatan': 4,
    'belanja': 5,
    'kecantikan': 6,
    'hiburan': 7,
    'pendidikan': 8,
    'olahraga': 9,
    'sedekah': 10,
    'darurat': 11,
    'lainnya': 12,
  };
  return map[title.toLowerCase()] ?? 12;
}
