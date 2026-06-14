import 'package:flutter/material.dart';

import '../../../../core/api/laravel_api_service.dart';
import '../../../../core/models/dashboard_models.dart';
import '../../../../core/repository/local_repository.dart';
import 'category_picker_sheet.dart';
import '../dashboard_shared.dart';
import 'wallet_picker_sheet.dart';

class BudgetFormDialog extends StatefulWidget {
  const BudgetFormDialog({super.key, required this.onSave});

  final ValueChanged<DashboardBudget> onSave;

  @override
  State<BudgetFormDialog> createState() => BudgetFormDialogState();
}

class BudgetFormDialogState extends State<BudgetFormDialog> {
  final _amountController = TextEditingController();
  String _category = 'Kategori';
  List<WalletItem> _wallets = [];
  int? _selectedWalletId;
  String _selectedWalletName = 'Dompet';

  @override
  void initState() {
    super.initState();
    _fetchWallets();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fetchWallets() async {
    final repo = const LocalRepository();
    try {
      final wallets = await LaravelApiService.instance.getWallets();
      if (wallets.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _wallets = wallets;
          _selectedWalletId = wallets.first.id;
          _selectedWalletName = wallets.first.name;
        });
        return;
      }
    } catch (_) {}
    final local = await repo.loadWallets();
    if (local.isNotEmpty && mounted) {
      setState(() {
        _wallets = local;
        _selectedWalletId = local.first.id;
        _selectedWalletName = local.first.name;
      });
    }
  }

  void _openWalletPicker() {
    showModalBottomSheet<int>(
      context: context,
      builder: (context) => WalletPickerSheet(
        wallets: _wallets,
        selectedId: _selectedWalletId,
        onSelected: (id, name) {
          Navigator.of(context).pop();
          setState(() {
            _selectedWalletId = id;
            _selectedWalletName = name;
          });
        },
      ),
    );
  }

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
        onSelected: (category) {
          setState(() => _category = category);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _save() {
    final amount = parseCurrency(_amountController.text);
    if (_category == 'Kategori' || amount <= 0 || _selectedWalletId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi dompet, kategori, dan nominal budget')),
      );
      return;
    }

    widget.onSave(
      DashboardBudget(
        title: _category,
        amountValue: amount,
        remaining: 'sisa 100%',
        progress: 0,
        icon: categoryIcon(_category),
        walletId: _selectedWalletId,
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
        padding: const EdgeInsets.fromLTRB(16, 34, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Buat budget baru untuk\nmengatur keuangan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: DialogSelectField(
                    label: 'Dompet',
                    value: _selectedWalletName,
                    icon: Icons.credit_card_rounded,
                    trailing: Icons.keyboard_arrow_down_rounded,
                    onTap: _openWalletPicker,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: DialogSelectField(
                    label: 'Kategori',
                    value: _category,
                    icon: Icons.work_rounded,
                    trailing: Icons.chevron_right_rounded,
                    muted: _category == 'Kategori',
                    onTap: _pickCategory,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Budget',
                style: TextStyle(
                  color: SakuColors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan Nominal Budget..',
                filled: true,
                fillColor: SakuColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: const BorderSide(color: SakuColors.neutral300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: const BorderSide(color: SakuColors.neutral300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: const BorderSide(color: SakuColors.blue300),
                ),
              ),
            ),
            const SizedBox(height: 54),
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
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: SakuColors.blue300,
                      foregroundColor: SakuColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
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
