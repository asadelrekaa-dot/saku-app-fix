import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/dashboard_models.dart';
import '../utils/format_utils.dart';

Color _colorFor(int amountValue) {
  return amountValue < 0
      ? const Color(0xFFF97373)
      : const Color(0xFF2DBD87);
}

class LocalRepository {
  const LocalRepository();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    return openDatabase(
      '$path/saku.db',
      version: 9,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        note TEXT NOT NULL,
        amount_value INTEGER NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        settled INTEGER NOT NULL DEFAULT 0,
        api_id INTEGER,
        api_type TEXT,
        raw_date TEXT,
        deadline TEXT,
        created_at TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');
    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount_value INTEGER NOT NULL,
        api_id INTEGER,
        wallet_id INTEGER,
        created_at TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');
    await db.execute('''
      CREATE TABLE wallets (
        id INTEGER PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        balance INTEGER NOT NULL,
        icon TEXT
      )
    ''');
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE budgets (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          amount_value INTEGER NOT NULL,
          api_id INTEGER,
          created_at TEXT NOT NULL DEFAULT (datetime('now'))
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE wallets (
          id INTEGER PRIMARY KEY NOT NULL,
          name TEXT NOT NULL,
          balance INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE transactions ADD COLUMN raw_date TEXT');
    }
    if (oldVersion < 5) {
      await db.delete('transactions');
      await db.delete('budgets');
      await db.delete('wallets');
    }
    if (oldVersion < 6) {
      try {
        await db.execute('ALTER TABLE transactions ADD COLUMN raw_date TEXT');
      } catch (_) {
        // Column already exists, ignore.
      }
    }
    if (oldVersion < 7) {
      try {
        await db.execute('ALTER TABLE transactions ADD COLUMN deadline TEXT');
      } catch (_) {
        // Column already exists, ignore.
      }
    }
    if (oldVersion < 8) {
      try {
        await db.execute('ALTER TABLE budgets ADD COLUMN wallet_id INTEGER');
      } catch (_) {
        // Column already exists, ignore.
      }
    }
    if (oldVersion < 9) {
      try {
        await db.execute('ALTER TABLE wallets ADD COLUMN icon TEXT');
      } catch (_) {
        // Column already exists, ignore.
      }
    }
  }

  // ── Transactions ──

  Future<List<DashboardTransaction>> loadTransactions() async {
    try {
      final db = await database;
      final rows = await db.query('transactions', orderBy: 'created_at DESC');
      return rows.map(_rowToTransaction).toList();
    } catch (e, s) {
      log('[LocalRepository] loadTransactions error', error: e, stackTrace: s);
      return [];
    }
  }

  DashboardTransaction _rowToTransaction(Map<String, dynamic> row) {
    final amountValue = (row['amount_value'] as int?) ?? 0;
    return DashboardTransaction(
      title: (row['title'] as String?) ?? '',
      note: (row['note'] as String?) ?? '',
      amountValue: amountValue,
      date: (row['date'] as String?) ?? '',
      time: (row['time'] as String?) ?? '',
      icon: categoryIcon((row['title'] as String?) ?? ''),
      color: _colorFor(amountValue),
      settled: (row['settled'] as int?) == 1,
      apiId: row['api_id'] as int?,
      apiType: row['api_type'] as String?,
      rawDate: row['raw_date'] as String?,
      deadline: row['deadline'] as String?,
    );
  }

  Future<void> addTransaction(DashboardTransaction item) async {
    try {
      final db = await database;
      await db.insert('transactions', _toMap(item));
    } catch (e, s) {
      log('[LocalRepository] addTransaction error', error: e, stackTrace: s);
    }
  }

  Future<void> deleteTransaction(DashboardTransaction item) async {
    try {
      final db = await database;
      await db.delete(
        'transactions',
        where:
            'title = ? AND note = ? AND amount_value = ? AND date = ? AND time = ?',
        whereArgs: [
          item.title,
          item.note,
          item.amountValue,
          item.date,
          item.time,
        ],
      );
    } catch (e, s) {
      log('[LocalRepository] deleteTransaction error', error: e, stackTrace: s);
    }
  }

  Future<void> updateTransaction(
    DashboardTransaction oldItem,
    DashboardTransaction newItem,
  ) async {
    try {
      final db = await database;
      await db.update(
        'transactions',
        _toMap(newItem),
        where:
            'title = ? AND note = ? AND amount_value = ? AND date = ? AND time = ?',
        whereArgs: [
          oldItem.title,
          oldItem.note,
          oldItem.amountValue,
          oldItem.date,
          oldItem.time,
        ],
      );
    } catch (e, s) {
      log('[LocalRepository] updateTransaction error', error: e, stackTrace: s);
    }
  }

  Future<void> replaceAllTransactions(List<DashboardTransaction> items) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('transactions');
        for (final item in items) {
          await txn.insert('transactions', _toMap(item));
        }
      });
    } catch (e, s) {
      log('[LocalRepository] replaceAllTransactions error', error: e, stackTrace: s);
    }
  }

  // ── Budgets ──

  Future<List<DashboardBudget>> loadBudgets() async {
    try {
      final db = await database;
      final rows = await db.query('budgets', orderBy: 'created_at DESC');
      return rows.map(_rowToBudget).toList();
    } catch (e, s) {
      log('[LocalRepository] loadBudgets error', error: e, stackTrace: s);
      return [];
    }
  }

  DashboardBudget _rowToBudget(Map<String, dynamic> row) {
    final amountValue = (row['amount_value'] as int?) ?? 0;
    return DashboardBudget(
      title: (row['title'] as String?) ?? '',
      amountValue: amountValue,
      remaining: 'sisa Rp 0',
      progress: 0,
      icon: categoryIcon((row['title'] as String?) ?? ''),
      apiId: row['api_id'] as int?,
      walletId: row['wallet_id'] as int?,
    );
  }

  Future<void> addBudget(DashboardBudget item) async {
    try {
      final db = await database;
      await db.insert('budgets', _budgetToMap(item));
    } catch (e, s) {
      log('[LocalRepository] addBudget error', error: e, stackTrace: s);
    }
  }

  Future<void> replaceAllBudgets(List<DashboardBudget> items) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('budgets');
        for (final item in items) {
          await txn.insert('budgets', _budgetToMap(item));
        }
      });
    } catch (e, s) {
      log('[LocalRepository] replaceAllBudgets error', error: e, stackTrace: s);
    }
  }

  // ── Wallets ──

  Future<List<WalletItem>> loadWallets() async {
    try {
      final db = await database;
      final rows = await db.query('wallets');
      return rows.map((row) => WalletItem(
        id: row['id'] as int?,
        name: (row['name'] as String?) ?? '',
        balance: (row['balance'] as int?) ?? 0,
        icon: row['icon'] as String?,
      )).toList();
    } catch (e, s) {
      log('[LocalRepository] loadWallets error', error: e, stackTrace: s);
      return [];
    }
  }

  Future<void> replaceAllWallets(List<WalletItem> items) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('wallets');
        for (final item in items) {
          await txn.insert('wallets', {
            'id': item.id,
            'name': item.name,
            'balance': item.balance,
            'icon': item.icon,
          });
        }
      });
    } catch (e, s) {
      log('[LocalRepository] replaceAllWallets error', error: e, stackTrace: s);
    }
  }

  // ── Model conversion ──

  Map<String, dynamic> _toMap(DashboardTransaction item) {
    return {
      'title': item.title,
      'note': item.note,
      'amount_value': item.amountValue,
      'date': item.date,
      'time': item.time,
      'settled': item.settled ? 1 : 0,
      'api_id': item.apiId,
      'api_type': item.apiType,
      'raw_date': item.rawDate,
      'deadline': item.deadline,
    };
  }

  Map<String, dynamic> _budgetToMap(DashboardBudget item) {
    return {
      'title': item.title,
      'amount_value': item.amountValue,
      'api_id': item.apiId,
      'wallet_id': item.walletId,
    };
  }
}
