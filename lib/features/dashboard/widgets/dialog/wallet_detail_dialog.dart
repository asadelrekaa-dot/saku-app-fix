import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/models/dashboard_models.dart';
import '../dashboard_shared.dart';

class WalletDetailDialog extends StatelessWidget {
  const WalletDetailDialog({
    super.key,
    required this.item,
    this.onDelete,
    this.onEdit,
  });

  final WalletItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: SakuColors.blue300,
              child: item.icon != null
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/icons/dompet/${item.icon}',
                        width: 28,
                        height: 28,
                      ),
                    )
                  : const Icon(Icons.account_balance_wallet_rounded,
                      color: SakuColors.white),
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Rp ${formatPlain(item.balance)}',
              style: const TextStyle(
                color: SakuColors.neutral600,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (onEdit != null) ...[
                  Expanded(
                    child: DialogActionButton(
                      label: 'Edit',
                      icon: Icons.edit_rounded,
                      color: SakuColors.blue700,
                      bgColor: SakuColors.blue50,
                      onTap: () {
                        Navigator.of(context).pop();
                        onEdit?.call();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (onDelete != null) ...[
                  Expanded(
                    child: DialogActionButton(
                      label: 'Hapus',
                      icon: Icons.delete_outline_rounded,
                      color: Colors.red,
                      bgColor: Colors.red.shade50,
                      onTap: () {
                        Navigator.of(context).pop();
                        onDelete?.call();
                      },
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: SakuColors.neutral600,
                  side: const BorderSide(color: SakuColors.neutral300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Tutup',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogActionButton extends StatelessWidget {
  const DialogActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
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
