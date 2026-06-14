import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../dashboard_shared.dart';

const _dompetIcons = [
  'affiliate.svg',
  'Bank.svg',
  'beri pinjaman.svg',
  'card.svg',
  'cash.svg',
  'catatan.svg',
  'Darurat.svg',
  'dompet2.svg',
  'emoney.svg',
  'kartu 2.svg',
  'kategori.svg',
  'pemasukan 1.svg',
  'pengeluaran1.svg',
  'Penjualan.svg',
  'receh.svg',
  'receipt.svg',
  'uang saku.svg',
];

class WalletIconPicker extends StatelessWidget {
  const WalletIconPicker({
    super.key,
    required this.selectedIcon,
    required this.onSelected,
  });

  final String? selectedIcon;
  final ValueChanged<String> onSelected;

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
              'Pilih Icon',
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
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: _dompetIcons.length,
                itemBuilder: (context, index) {
                  final iconName = _dompetIcons[index];
                  final selected = iconName == selectedIcon;
                  return GestureDetector(
                    onTap: () => onSelected(iconName),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? SakuColors.blue100
                            : SakuColors.neutral100,
                        borderRadius: BorderRadius.circular(14),
                        border: selected
                            ? Border.all(color: SakuColors.blue300, width: 2)
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/icons/dompet/$iconName',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
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
