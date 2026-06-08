import 'package:flutter/material.dart';
import 'dashboard_shared.dart'; // Wajib diimport untuk mengakses SakuColors dan categoryIcon

enum CategoryKind { expense, income }

class CategoryPickerComponent {
  static const List<String> _expenseCategories = [
    'Makanan', 'Transportasi', 'Rumah', 'Kesehatan', 'Belanja',
    'Kecantikan', 'Hiburan', 'Pendidikan', 'Olahraga', 'Darurat',
    'Sedekah', 'Lainnya',
  ];

  static const List<String> _incomeCategories = [
    'Gaji', 'Freelance', 'Bisnis', 'Hadiah', 'Penjualan',
    'Investasi', 'Sewa', 'Uang Saku', 'Lainnya',
  ];

  static List<String> _categoriesForKind(CategoryKind kind) {
    return kind == CategoryKind.income ? _incomeCategories : _expenseCategories;
  }

  /// 1. Tampilan BOTTOM SHEET (Muncul dari bawah)
  static Future<String?> showAsBottomSheet({
    required BuildContext context,
    required String selectedCategory,
    CategoryKind kind = CategoryKind.expense,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SakuColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _CategorySheetWidget(
        selectedCategory: selectedCategory,
        kind: kind,
      ),
    );
  }

  /// 2. Tampilan DIALOG (Pop-up di tengah screen)
  static Future<String?> showAsDialog({
    required BuildContext context,
    required String selectedCategory,
    CategoryKind kind = CategoryKind.expense,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero, // FIXED: Sudah diperbaiki dari EdgeInsets.,
        backgroundColor: SakuColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: _CategorySheetWidget(
            selectedCategory: selectedCategory,
            kind: kind,
          ),
        ),
      ),
    );
  }
}

/// Grid Utama Kategori
class _CategorySheetWidget extends StatelessWidget {
  const _CategorySheetWidget({
    required this.selectedCategory,
    required this.kind,
  });

  final String selectedCategory;
  final CategoryKind kind;

  @override
  Widget build(BuildContext context) {
    final items = CategoryPickerComponent._categoriesForKind(kind);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kind == CategoryKind.income ? 'Pilih Kategori Pemasukan' : 'Pilih Kategori Pengeluaran',
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final category = items[index];
                  final isSelected = category == selectedCategory;
                  return _CategoryChoiceTile(
                    title: category,
                    selected: isSelected,
                    onTap: () => Navigator.of(context).pop(category),
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

/// Desain Tile Item Kategori (Menggunakan warna khas Saku)
class _CategoryChoiceTile extends StatelessWidget {
  const _CategoryChoiceTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
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
                radius: 22,
                backgroundColor: selected ? SakuColors.blue300 : SakuColors.white,
                child: Icon(
                  categoryIcon(title), // Memakai fungsi icon bawaan Saku
                  color: selected ? SakuColors.white : SakuColors.mango500,
                ),
              ),
              const SizedBox(height: 8),
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