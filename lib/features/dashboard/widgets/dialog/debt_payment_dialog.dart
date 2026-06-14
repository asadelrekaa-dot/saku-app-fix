import 'package:flutter/material.dart';

import '../../../../core/models/dashboard_models.dart';
import '../dashboard_shared.dart';
import 'wallet_picker_sheet.dart';

class DebtPaymentDialog extends StatefulWidget {
  const DebtPaymentDialog({
    super.key,
    required this.item,
    required this.wallets,
    required this.onMarkSettled,
  });

  final DashboardTransaction item;
  final List<WalletItem> wallets;
  final ValueChanged<int> onMarkSettled;

  @override
  State<DebtPaymentDialog> createState() => DebtPaymentDialogState();
}

class DebtPaymentDialogState extends State<DebtPaymentDialog> {
  int? _selectedWalletId;
  String _selectedWalletName = 'Dompet';

  @override
  void initState() {
    super.initState();
    if (widget.wallets.isNotEmpty) {
      _selectedWalletId = widget.wallets.first.id;
      _selectedWalletName = widget.wallets.first.name;
    }
  }

  void _openWalletPicker() {
    showModalBottomSheet<int>(
      context: context,
      builder: (ctx) => WalletPickerSheet(
        wallets: widget.wallets,
        selectedId: _selectedWalletId,
        onSelected: (id, name) {
          Navigator.of(ctx).pop();
          setState(() {
            _selectedWalletId = id;
            _selectedWalletName = name;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bayar hutang dari dompet mana?',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
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
                const SizedBox(width: 10),
                const Expanded(
                  child: DialogSelectField(
                    label: 'Tanggal Lunas',
                    value: '—',
                    icon: null,
                    trailing: Icons.calendar_month_rounded,
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: _selectedWalletId != null
                        ? () => widget.onMarkSettled(_selectedWalletId!)
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.item.settled
                          ? SakuColors.success
                          : SakuColors.neutral300,
                      foregroundColor: widget.item.settled
                          ? SakuColors.white
                          : SakuColors.neutral600,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      widget.item.settled ? 'Sudah Lunas' : 'Lunas',
                      style: const TextStyle(fontWeight: FontWeight.w900),
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
