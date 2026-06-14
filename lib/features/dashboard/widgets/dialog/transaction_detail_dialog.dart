import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/models/dashboard_models.dart';
import '../dashboard_shared.dart';
import 'debt_payment_dialog.dart';
import 'loan_detail_dialog.dart';

class TransactionDetailDialog extends StatelessWidget {
  const TransactionDetailDialog({
    super.key,
    required this.item,
    required this.wallets,
    required this.onDelete,
    required this.onEdit,
    required this.onMarkSettled,
  });

  final DashboardTransaction item;
  final List<WalletItem> wallets;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<int> onMarkSettled;

  bool get _isLoan => item.title == 'Beri Pinjaman';
  bool get _isDebt => item.title == 'Hutang';

  @override
  Widget build(BuildContext context) {
    if (_isLoan) {
      return LoanDetailDialog(
        item: item,
        onDelete: onDelete,
        onEdit: onEdit,
        onMarkSettled: () => onMarkSettled(wallets.first.id ?? 1),
      );
    }

    if (_isDebt && !item.settled) {
      return DebtPaymentDialog(
        item: item,
        wallets: wallets,
        onMarkSettled: onMarkSettled,
      );
    }

    return StandardTransactionDetailDialog(
      item: item,
      onDelete: _isDebt ? null : onDelete,
      onEdit: _isDebt ? null : onEdit,
    );
  }
}

class StandardTransactionDetailDialog extends StatelessWidget {
  const StandardTransactionDetailDialog({
    super.key,
    required this.item,
    this.onDelete,
    this.onEdit,
  });

  final DashboardTransaction item;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  bool get _isExpense => item.amountValue < 0;

  @override
  Widget build(BuildContext context) {
    final categoryAssetPath = categoryAsset(item.title);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),
            decoration: BoxDecoration(
              color: SakuColors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: SakuColors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isExpense ? 'Pengeluaran' : 'Pemasukan',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: SakuColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            'Selasa, ${item.date}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: SakuColors.neutral300,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    SizedBox(
                      width: 116,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Rp ${formatPlain(item.amountValue.abs())}',
                          maxLines: 1,
                          style: const TextStyle(
                            color: SakuColors.neutral300,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                const DashedSeparator(),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TransactionDetailColumn(
                        label: 'Catatan',
                        value: item.note,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const TransactionDetailColumn(
                      label: 'Dompet',
                      alignment: CrossAxisAlignment.center,
                      child: LoanWalletIcon(),
                    ),
                    const SizedBox(width: 18),
                    TransactionDetailColumn(
                      label: item.title,
                      alignment: CrossAxisAlignment.center,
                      child: CategoryDetailIcon(
                        icon: item.icon,
                        color: item.color,
                        assetPath: categoryAssetPath,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: SakuColors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: SakuColors.black.withValues(alpha: 0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                if (onDelete != null)
                  IconButton(
                    tooltip: 'Hapus',
                    onPressed: onDelete,
                    icon:
                        const Icon(Icons.delete_rounded, color: Colors.red),
                  ),
                if (onEdit != null)
                  IconButton(
                    tooltip: 'Edit',
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded,
                        color: SakuColors.blue700),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: 'Tutup',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.check_rounded,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionDetailColumn extends StatelessWidget {
  const TransactionDetailColumn({
    super.key,
    required this.label,
    this.value,
    this.child,
    this.alignment = CrossAxisAlignment.start,
  });

  final String label;
  final String? value;
  final Widget? child;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: SakuColors.black,
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        if (child != null)
          child!
        else
          Text(
            value ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SakuColors.neutral300,
              fontSize: 15,
              height: 1.12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
      ],
    );
  }
}

class CategoryDetailIcon extends StatelessWidget {
  const CategoryDetailIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.assetPath,
  });

  final IconData icon;
  final Color color;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return SvgPicture.asset(
        assetPath!,
        width: 34,
        height: 34,
        fit: BoxFit.contain,
      );
    }

    return Icon(icon, color: color, size: 32);
  }
}
