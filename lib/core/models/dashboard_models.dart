import 'package:flutter/material.dart';

import '../utils/format_utils.dart';

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

const _noValue = Object();
