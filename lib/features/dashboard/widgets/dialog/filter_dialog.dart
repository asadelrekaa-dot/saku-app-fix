import 'package:flutter/material.dart';

import '../dashboard_shared.dart';
import 'category_picker_sheet.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
    required this.selectedCategory,
    required this.onApply,
  });

  final String selectedCategory;
  final ValueChanged<String> onApply;

  @override
  State<FilterDialog> createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  late String _category = widget.selectedCategory;

  void _pickCategory() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: SakuColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => CategoryPickerSheet(
        selectedCategory: _category,
        kind: CategoryKind.expense,
        includeAll: true,
        onSelected: (category) {
          setState(() => _category = category);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cari berdasarkan filter\ntanggal dan kategori',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 17,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DialogSelectField(
                    label: 'Kategori',
                    value: _category == 'Semua' ? 'Semua' : _category,
                    icon: Icons.work_rounded,
                    trailing: Icons.chevron_right_rounded,
                    muted: _category == 'Semua',
                    onTap: _pickCategory,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: DialogSelectField(
                    label: 'Tanggal',
                    value: 'Pilih tanggal',
                    icon: null,
                    trailing: Icons.keyboard_arrow_down_rounded,
                    muted: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SakuColors.mango500,
                      side: const BorderSide(
                        color: SakuColors.mango500,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: FilledButton(
                    onPressed: () => widget.onApply(_category),
                    style: FilledButton.styleFrom(
                      backgroundColor: SakuColors.blue300,
                      foregroundColor: SakuColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Cari',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
