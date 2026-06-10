import 'dart:developer';

import '../api/laravel_api_service.dart';

class SyncResult {
  const SyncResult(this.apiId, this.apiType);

  final int apiId;
  final String apiType;
}

abstract class ITransactionRepository {
  Future<SyncResult?> createTransaction({
    required String title,
    required String note,
    required int amountValue,
  });

  Future<void> updateTransaction({
    required int apiId,
    required String apiType,
    required String title,
    required String note,
    required int amountValue,
  });

  Future<void> deleteTransaction({
    required int apiId,
    required String apiType,
  });

  Future<void> markSettled({
    required int apiId,
    required String apiType,
  });
}

class ApiTransactionRepository implements ITransactionRepository {
  const ApiTransactionRepository();

  @override
  Future<SyncResult?> createTransaction({
    required String title,
    required String note,
    required int amountValue,
  }) async {
    try {
      final result = await LaravelApiService.instance.createTransaction(
        LaravelTransactionDraft(
          title: title,
          note: note,
          amountValue: amountValue,
        ),
      );
      return SyncResult(result.apiId, result.apiType);
    } catch (e, s) {
      log('[TransactionRepository] createTransaction failed', error: e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<void> updateTransaction({
    required int apiId,
    required String apiType,
    required String title,
    required String note,
    required int amountValue,
  }) async {
    try {
      await LaravelApiService.instance.updateTransaction(
        apiId: apiId,
        apiType: apiType,
        item: LaravelTransactionDraft(
          title: title,
          note: note,
          amountValue: amountValue,
        ),
      );
    } catch (e, s) {
      log('[TransactionRepository] updateTransaction failed', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> deleteTransaction({
    required int apiId,
    required String apiType,
  }) async {
    try {
      await LaravelApiService.instance.deleteTransaction(
        apiId: apiId,
        apiType: apiType,
      );
    } catch (e, s) {
      log('[TransactionRepository] deleteTransaction failed', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> markSettled({
    required int apiId,
    required String apiType,
  }) async {
    try {
      await LaravelApiService.instance.markSettled(
        apiId: apiId,
        apiType: apiType,
      );
    } catch (e, s) {
      log('[TransactionRepository] markSettled failed', error: e, stackTrace: s);
    }
  }
}
