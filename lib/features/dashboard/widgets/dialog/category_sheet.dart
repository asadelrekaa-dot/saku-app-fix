import 'package:flutter/material.dart';

import '../dashboard_shared.dart';

class CategorySheet extends StatelessWidget {
  const CategorySheet({super.key, required this.categories});

  final List<ChartCategory> categories;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Semua Kategori',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            for (final cat in categories)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: cat.color,
                  child: Icon(cat.icon, color: SakuColors.black),
                ),
                title: Text(cat.title),
                subtitle: Text('Rp ${formatPlain(cat.amountValue)}'),
                trailing: Text(
                  '${cat.percent}%',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ChartCategory {
  const ChartCategory({
    required this.title,
    required this.percent,
    required this.amountValue,
    required this.icon,
    required this.color,
  });

  final String title;
  final int percent;
  final int amountValue;
  final IconData icon;
  final Color color;
}
