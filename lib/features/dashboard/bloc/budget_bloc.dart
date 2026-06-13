import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/laravel_api_service.dart';
import '../widgets/dashboard_shared.dart' show categoryIcon;
import 'dashboard_models.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc()
      : super(BudgetState(
          budgets: initialBudgets,
        )) {
    on<BudgetLoaded>(_onLoaded);
    on<BudgetAdded>(_onAdded);
    on<BudgetDeleted>(_onDeleted);
  }

  Future<void> _onLoaded(
    BudgetLoaded event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final list = await LaravelApiService.instance.getBudgets();
      final budgets = list.map(_parseBudget).toList();
      emit(state.copyWith(budgets: budgets, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAdded(
    BudgetAdded event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(budgets: [event.item, ...state.budgets]));
    try {
      final result = await LaravelApiService.instance.createBudget(
        kategoriId: _kategoriId(event.item.title),
        nominal: event.item.amountValue,
      );
      final apiId = result['id'] as int?;
      if (apiId != null) {
        emit(
          state.copyWith(
            budgets: state.budgets
                .map(
                  (b) => b == event.item ? b.copyWith(apiId: apiId) : b,
                )
                .toList(),
          ),
        );
      }
    } catch (e) {
      log('[BudgetBloc] API sync error', error: e);
    }
  }

  Future<void> _onDeleted(
    BudgetDeleted event,
    Emitter<BudgetState> emit,
  ) async {
    emit(
      state.copyWith(
        budgets: state.budgets.where((entry) => entry != event.item).toList(),
      ),
    );
    try {
      if (event.item.apiId != null) {
        await LaravelApiService.instance.deleteBudget(
          apiId: event.item.apiId!,
        );
      }
    } catch (e) {
      log('[BudgetBloc] API delete error', error: e);
    }
  }

  DashboardBudget _parseBudget(Map<String, dynamic> item) {
    final kategori = (item['kategori'] ?? 'Lainnya').toString();
    return DashboardBudget(
      title: kategori,
      amountValue: (item['nominal'] ?? 0) as int,
      remaining: 'sisa 100%',
      progress: 1,
      icon: categoryIcon(kategori),
      apiId: (item['id'] as int?),
    );
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
