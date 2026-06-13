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
      version: 2,
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
        created_at TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');
    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount_value INTEGER NOT NULL,
        created_at TEXT NOT NULL DEFAULT (datetime('now'))
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
          created_at TEXT NOT NULL DEFAULT (datetime('now'))
        )
      ''');
    }
  }

  Future<List<DashboardTransaction>> loadTransactions() async {
    try {
      final db = await database;
      final rows = await db.query('transactions', orderBy: 'created_at DESC');
      return rows.map((row) {
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
        );
      }).toList();
    } catch (e, s) {
      log('[LocalRepository] loadTransactions error', error: e, stackTrace: s);
      return [];
    }
  }

  Future<void> saveTransaction(DashboardTransaction item) async {
    try {
      final db = await database;
      await db.insert('transactions', _toMap(item));
    } catch (e, s) {
      log('[LocalRepository] saveTransaction error', error: e, stackTrace: s);
    }
  }

  Future<List<DashboardBudget>> loadBudgets() async {
    try {
      final db = await database;
      final rows = await db.query('budgets', orderBy: 'created_at DESC');
      return rows.map((row) {
        final amountValue = (row['amount_value'] as int?) ?? 0;
        return DashboardBudget(
          title: (row['title'] as String?) ?? '',
          amountValue: amountValue,
          remaining: 'sisa 100%',
          progress: 1,
          icon: categoryIcon((row['title'] as String?) ?? ''),
        );
      }).toList();
    } catch (e, s) {
      log('[LocalRepository] loadBudgets error', error: e, stackTrace: s);
      return [];
    }
  }

  Future<void> saveBudget(DashboardBudget item) async {
    try {
      final db = await database;
      await db.insert('budgets', {
        'title': item.title,
        'amount_value': item.amountValue,
      });
    } catch (e, s) {
      log('[LocalRepository] saveBudget error', error: e, stackTrace: s);
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
    };
  }
}
