import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../dashboard_shared.dart';

enum CategoryKind { expense, income }

List<String> categoriesForKind(CategoryKind kind) {
  return kind == CategoryKind.income
      ? CategoryPickerSheet._incomeCategories
      : CategoryPickerSheet._expenseCategories;
}

class CategoryPickerSheet extends StatelessWidget {
  const CategoryPickerSheet({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
    this.kind = CategoryKind.expense,
    this.includeAll = false,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;
  final CategoryKind kind;
  final bool includeAll;

  static const _expenseCategories = [
    'Makanan',
    'Transportasi',
    'Rumah',
    'Kesehatan',
    'Belanja',
    'Kecantikan',
    'Hiburan',
    'Pendidikan',
    'Olahraga',
    'Darurat',
    'Sedekah',
    'Lainnya',
  ];

  static const _incomeCategories = [
    'Gaji',
    'Freelance',
    'Bisnis',
    'Hadiah',
    'Penjualan',
    'Investasi',
    'Sewa',
    'Uang Saku',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    final baseItems = categoriesForKind(kind);
    final items = includeAll ? ['Semua', ...baseItems] : baseItems;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Kategori',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.90,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final category = items[index];
                  final selected = category == selectedCategory;
                  return CategoryChoiceTile(
                    title: category,
                    iconAsset: categoryAsset(category),
                    selected: selected,
                    onTap: () => onSelected(category),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChoiceTile extends StatelessWidget {
  const CategoryChoiceTile({super.key,
    required this.title,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String? iconAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? SakuColors.blue100 : SakuColors.neutral100,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    selected ? SakuColors.blue300 : SakuColors.white,
                child: iconAsset != null
                    ? ClipRect(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: SvgPicture.asset(
                            iconAsset!,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      )
                    : Icon(
                        categoryIcon(title),
                        color: selected ? SakuColors.white : SakuColors.mango500,
                        size: 22,
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
