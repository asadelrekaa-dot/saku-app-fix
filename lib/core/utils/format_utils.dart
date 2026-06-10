import 'package:flutter/material.dart';

String formatPlain(int value) {
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

int parseCurrency(String value) {
  return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}

String formatDate(DateTime date) {
  const months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String formatTime(DateTime date) {
  final hour = date.hour;
  final minute = date.minute.toString().padLeft(2, '0');
  final amPm = hour < 12 ? 'AM' : 'PM';
  final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '$hour12:$minute $amPm';
}

IconData categoryIcon(String category) {
  return switch (category) {
    'Makanan' => Icons.restaurant_rounded,
    'Transportasi' => Icons.directions_car_rounded,
    'Rumah' => Icons.home_rounded,
    'Belanja' => Icons.shopping_cart_rounded,
    'Pendidikan' => Icons.school_rounded,
    'Hiburan' => Icons.movie_rounded,
    'Kesehatan' => Icons.health_and_safety_rounded,
    'Kecantikan' => Icons.spa_rounded,
    'Olahraga' => Icons.sports_soccer_rounded,
    'Darurat' => Icons.emergency_rounded,
    'Sedekah' => Icons.volunteer_activism_rounded,
    'Hadiah' => Icons.card_giftcard_rounded,
    'Gaji' => Icons.account_balance_wallet_rounded,
    'Freelance' => Icons.self_improvement_rounded,
    'Bisnis' => Icons.handshake_rounded,
    'Penjualan' => Icons.storefront_rounded,
    'Investasi' => Icons.trending_up_rounded,
    'Sewa' => Icons.receipt_long_rounded,
    'Uang Saku' => Icons.savings_rounded,
    'Hutang' => Icons.payments_outlined,
    'Beri Pinjaman' => Icons.request_quote_outlined,
    'Semua' => Icons.apps_rounded,
    _ => Icons.work_rounded,
  };
}
