import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import '../../../core/api/laravel_api_service.dart';
import '../../../core/theme/app_colors.dart';

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

class DashboardBudget {
  const DashboardBudget({
    required this.title,
    required this.amountValue,
    required this.remaining,
    required this.progress,
    required this.icon,
  });

  final String title;
  final int amountValue;
  final String remaining;
  final double progress;
  final IconData icon;
}

class DashboardTransaction {
  const DashboardTransaction({
    required this.title,
    required this.note,
    required this.amountValue,
    required this.date,
    required this.time,
    required this.icon,
    required this.color,
    this.settled = false,
    this.apiId,
    this.apiType,
  });

  final String title;
  final String note;
  final int amountValue;
  final String date;
  final String time;
  final IconData icon;
  final Color color;
  final bool settled;
  final int? apiId;
  final String? apiType;

  String get amount {
    final sign = amountValue < 0 ? '-' : '+';
    return '$sign ${_formatPlainAmount(amountValue.abs())}';
  }

  DashboardTransaction copyWith({
    String? title,
    String? note,
    int? amountValue,
    String? date,
    String? time,
    IconData? icon,
    Color? color,
    bool? settled,
    Object? apiId = _noValue,
    Object? apiType = _noValue,
  }) {
    return DashboardTransaction(
      title: title ?? this.title,
      note: note ?? this.note,
      amountValue: amountValue ?? this.amountValue,
      date: date ?? this.date,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      settled: settled ?? this.settled,
      apiId: apiId == _noValue ? this.apiId : apiId as int?,
      apiType: apiType == _noValue ? this.apiType : apiType as String?,
    );
  }
}

class DashboardState {
  const DashboardState({
    required this.currentIndex,
    required this.surface,
    required this.transactions,
    required this.budgets,
    this.editingTransaction,
  });

  factory DashboardState.initial({bool openAddNote = false}) {
    return DashboardState(
      currentIndex: 0,
      surface:
          openAddNote ? DashboardSurface.addExpense : DashboardSurface.main,
      transactions: _initialTransactions,
      budgets: _initialBudgets,
    );
  }

  static const _initialBalance = 12045000;

  final int currentIndex;
  final DashboardSurface surface;
  final DashboardTransaction? editingTransaction;
  final List<DashboardTransaction> transactions;
  final List<DashboardBudget> budgets;

  int get currentBalance => transactions.fold<int>(
        _initialBalance,
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

  DashboardState copyWith({
    int? currentIndex,
    DashboardSurface? surface,
    Object? editingTransaction = _noValue,
    List<DashboardTransaction>? transactions,
    List<DashboardBudget>? budgets,
  }) {
    return DashboardState(
      currentIndex: currentIndex ?? this.currentIndex,
      surface: surface ?? this.surface,
      editingTransaction: editingTransaction == _noValue
          ? this.editingTransaction
          : editingTransaction as DashboardTransaction?,
      transactions: transactions ?? this.transactions,
      budgets: budgets ?? this.budgets,
    );
  }
}

sealed class DashboardEvent {
  const DashboardEvent();
}

class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

class DashboardMainShown extends DashboardEvent {
  const DashboardMainShown();
}

class DashboardSurfaceShown extends DashboardEvent {
  const DashboardSurfaceShown(this.surface);

  final DashboardSurface surface;
}

class DashboardAddNoteShown extends DashboardEvent {
  const DashboardAddNoteShown([this.mode = AddNoteMode.expense]);

  final AddNoteMode mode;
}

class DashboardTabSelected extends DashboardEvent {
  const DashboardTabSelected(this.index);

  final int index;
}

class DashboardTransactionAdded extends DashboardEvent {
  const DashboardTransactionAdded(this.item);

  final DashboardTransaction item;
}

class DashboardBudgetAdded extends DashboardEvent {
  const DashboardBudgetAdded(this.item);

  final DashboardBudget item;
}

class DashboardTransactionDeleted extends DashboardEvent {
  const DashboardTransactionDeleted(this.item);

  final DashboardTransaction item;
}

class DashboardTransactionSettled extends DashboardEvent {
  const DashboardTransactionSettled(this.item);

  final DashboardTransaction item;
}

class DashboardEditTransactionOpened extends DashboardEvent {
  const DashboardEditTransactionOpened(this.item);

  final DashboardTransaction item;
}

class DashboardTransactionUpdated extends DashboardEvent {
  const DashboardTransactionUpdated({
    required this.oldItem,
    required this.newItem,
  });

  final DashboardTransaction oldItem;
  final DashboardTransaction newItem;
}

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
    on<DashboardTransactionDeleted>(_onTransactionDeleted);
    on<DashboardTransactionSettled>(_onTransactionSettled);
    on<DashboardEditTransactionOpened>(_onEditTransactionOpened);
    on<DashboardTransactionUpdated>(_onTransactionUpdated);
  }

  static const _homeWidgetProvider = 'SakuSummaryWidgetProvider';

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    await _syncHomeWidget();
  }

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
    emit(
      state.copyWith(
        transactions: [event.item, ...state.transactions],
        surface: DashboardSurface.main,
        currentIndex: 1,
      ),
    );
    await _syncHomeWidget();
    await _syncTransactionToApi(event.item, emit);
  }

  void _onBudgetAdded(
    DashboardBudgetAdded event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(budgets: [event.item, ...state.budgets]));
  }

  Future<void> _onTransactionDeleted(
    DashboardTransactionDeleted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      state.copyWith(
        transactions:
            state.transactions.where((entry) => entry != event.item).toList(),
      ),
    );
    await _syncHomeWidget();
  }

  Future<void> _onTransactionSettled(
    DashboardTransactionSettled event,
    Emitter<DashboardState> emit,
  ) async {
    final updated = state.transactions
        .map((entry) =>
            entry == event.item ? entry.copyWith(settled: true) : entry)
        .toList();
    emit(state.copyWith(transactions: updated));
    await _syncHomeWidget();
    try {
      await LaravelApiService.instance.markSettled(
        apiId: event.item.apiId,
        apiType: event.item.apiType,
      );
    } catch (_) {
      // The app remains local-first when the Laravel API is not reachable yet.
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
    await _syncHomeWidget();
  }

  Future<void> _syncHomeWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'balance',
        'Rp ${_formatPlainAmount(state.currentBalance)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'expense',
        'Rp ${_formatPlainAmount(state.currentExpense)}',
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

  Future<void> _syncTransactionToApi(
    DashboardTransaction item,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final synced = await LaravelApiService.instance.createTransaction(
        LaravelTransactionDraft(
          title: item.title,
          note: item.note,
          amountValue: item.amountValue,
        ),
      );
      final updated = state.transactions
          .map(
            (entry) => entry == item
                ? entry.copyWith(
                    apiId: synced.apiId,
                    apiType: synced.apiType,
                  )
                : entry,
          )
          .toList();
      emit(state.copyWith(transactions: updated));
    } catch (_) {
      // UI remains local-first when the Laravel API is not reachable yet.
    }
  }
}

const _noValue = Object();

const _initialTransactions = [
  DashboardTransaction(
    title: 'Makanan',
    note: 'Beli jajan kopi sama temen',
    amountValue: -30000,
    date: '18 April 2026',
    time: '11:55 AM',
    icon: Icons.restaurant_rounded,
    color: SakuColors.danger,
  ),
  DashboardTransaction(
    title: 'Hadiah',
    note: 'THR dari bos',
    amountValue: 30000,
    date: '18 April 2026',
    time: '11:55 AM',
    icon: Icons.card_giftcard_rounded,
    color: SakuColors.success,
  ),
  DashboardTransaction(
    title: 'Transportasi',
    note: 'Bensin pulang kampus',
    amountValue: -45000,
    date: '17 April 2026',
    time: '09:20 AM',
    icon: Icons.directions_car_rounded,
    color: SakuColors.danger,
  ),
];

const _initialBudgets = [
  DashboardBudget(
    title: 'Transportasi',
    amountValue: 200000,
    remaining: 'sisa 50%',
    progress: 0.5,
    icon: Icons.directions_car_rounded,
  ),
  DashboardBudget(
    title: 'Belanja',
    amountValue: 150000,
    remaining: 'sisa 40%',
    progress: 0.4,
    icon: Icons.shopping_cart_rounded,
  ),
  DashboardBudget(
    title: 'Skincare',
    amountValue: 300000,
    remaining: 'sisa 35%',
    progress: 0.35,
    icon: Icons.spa_rounded,
  ),
];

String _formatPlainAmount(int value) {
  final text = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final position = text.length - i;
    buffer.write(text[i]);
    if (position > 1 && position % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}
