import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/models/dashboard_models.dart' show WalletItem;
import '../dashboard_shared.dart';

class WalletPicker extends StatelessWidget {
  const WalletPicker({
    super.key,
    required this.walletName,
    required this.onTap,
    this.walletIcon,
  });

  final String walletName;
  final VoidCallback onTap;
  final String? walletIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: SakuColors.neutral300),
          ),
          child: Row(
            children: [
              if (walletIcon != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/icons/dompet/$walletIcon',
                    width: 22,
                    height: 22,
                  ),
                )
              else
                const Icon(Icons.credit_card_rounded,
                    color: SakuColors.mango500),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  walletName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SakuColors.neutral700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  color: SakuColors.black),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletPickerSheet extends StatelessWidget {
  const WalletPickerSheet({super.key,
    required this.wallets,
    required this.selectedId,
    required this.onSelected,
  });

  final List<WalletItem> wallets;
  final int? selectedId;
  final void Function(int id, String name) onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Dompet',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            if (wallets.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Belum ada dompet.\nBuat dompet dulu di halaman Profil.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: SakuColors.neutral600,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ...List.generate(wallets.length, (index) {
                final wallet = wallets[index];
                final selected = wallet.id == selectedId;
                return WalletTile(
                  name: wallet.name,
                  balance: wallet.balance,
                  selected: selected,
                  icon: wallet.icon,
                  onTap: () => onSelected(wallet.id!, wallet.name),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class WalletTile extends StatelessWidget {
  const WalletTile({super.key,
    required this.name,
    required this.balance,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String name;
  final int balance;
  final bool selected;
  final VoidCallback onTap;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? SakuColors.blue50 : SakuColors.neutral50,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: SvgPicture.asset(
                      'assets/icons/dompet/$icon',
                      width: 28,
                      height: 28,
                    ),
                  )
                else
                  const Icon(Icons.credit_card_rounded,
                      color: SakuColors.mango500),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatPlain(balance),
                        style: const TextStyle(
                          color: SakuColors.neutral600,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle_rounded,
                      color: SakuColors.blue300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
