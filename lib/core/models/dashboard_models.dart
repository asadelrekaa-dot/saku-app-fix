import 'package:flutter/material.dart';

import '../utils/format_utils.dart';

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
    this.apiId,
    this.walletId,
  });

  final String title;
  final int amountValue;
  final String remaining;
  final double progress;
  final IconData icon;
  final int? apiId;
  final int? walletId;

  DashboardBudget copyWith({
    String? title,
    int? amountValue,
    String? remaining,
    double? progress,
    IconData? icon,
    Object? apiId = _noValue,
    Object? walletId = _noValue,
  }) {
    return DashboardBudget(
      title: title ?? this.title,
      amountValue: amountValue ?? this.amountValue,
      remaining: remaining ?? this.remaining,
      progress: progress ?? this.progress,
      icon: icon ?? this.icon,
      apiId: apiId == _noValue ? this.apiId : apiId as int?,
      walletId: walletId == _noValue ? this.walletId : walletId as int?,
    );
  }
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
    this.rawDate,
    this.deadline,
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
  final String? rawDate;
  final String? deadline;

  String get amount {
    final sign = amountValue < 0 ? '-' : '+';
    return '$sign ${formatPlain(amountValue.abs())}';
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
    Object? rawDate = _noValue,
    Object? deadline = _noValue,
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
      rawDate: rawDate == _noValue ? this.rawDate : rawDate as String?,
      deadline: deadline == _noValue ? this.deadline : deadline as String?,
    );
  }
}

class WalletItem {
  const WalletItem({required this.name, required this.balance, this.id});

  final int? id;
  final String name;
  final int balance;
}

String formatPlainAmount(int value) {
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

const List<DashboardTransaction> initialTransactions = [];
const List<DashboardBudget> initialBudgets = [];

const _noValue = Object();
