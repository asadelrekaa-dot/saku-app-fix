// notification_model.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class NotificationItem {
  final int id;
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.isRead,
  });

  // Konstruktor khusus untuk mengubah Map JSON dari Laravel menjadi Object Flutter
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      icon: _parseIcon(json['icon']),
      iconColor: _parseColor(json['icon_color']),
      isRead: json['is_read'] ?? false,
    );
  }

  // Helper untuk mengubah string database menjadi IconData Flutter
  static IconData _parseIcon(String? iconName) {
    switch (iconName) {
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'trending_down':
        return Icons.trending_down_rounded;
      case 'edit_note':
      default:
        return Icons.edit_note_rounded;
    }
  }

  static Color _parseColor(String? colorName) {
    switch (colorName) {
      case 'danger':
        return SakuColors.danger;
      case 'success':
        return SakuColors.success;
      case 'neutral':
      default:
        return SakuColors.neutral700;
    }
  }
}