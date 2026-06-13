import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export '../../../core/theme/app_colors.dart';
export '../../../core/utils/format_utils.dart';
export '../../../core/models/dashboard_models.dart';
export '../bloc/dashboard/dashboard_bloc.dart';

class ChildPageTopBar extends StatelessWidget {
  const ChildPageTopBar({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SakuColors.white,
        boxShadow: [
          BoxShadow(
            color: SakuColors.black.withValues(alpha: 0.16),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            const SizedBox(width: 14),
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left_rounded, size: 34),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogSelectField extends StatelessWidget {
  const DialogSelectField({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    required this.trailing,
    this.muted = false,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;
  final IconData trailing;
  final bool muted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: SakuColors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: SakuColors.white,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: SakuColors.neutral300),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: SakuColors.mango500, size: 22),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: muted
                            ? SakuColors.neutral300
                            : SakuColors.neutral700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(trailing, color: SakuColors.black),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: cardDecoration(radius: 18),
      child: Column(
        children: [
          Icon(icon, color: SakuColors.neutral300, size: 42),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: SakuColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: SakuColors.neutral300,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.fromUser,
    required this.time,
  });

  final String text;
  final bool fromUser;
  final String time;
}

class WalletItem {
  const WalletItem({required this.name, required this.balance});

  final String name;
  final int balance;
}

BoxDecoration cardDecoration({double radius = 20}) {
  return BoxDecoration(
    color: SakuColors.white,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: SakuColors.black.withValues(alpha: 0.06),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

void showInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: SakuColors.neutral600,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: SakuColors.blue300,
                  foregroundColor: SakuColors.white,
                ),
                child: const Text('Mengerti'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String? categoryAsset(String category) {
  return switch (category) {
    'Makanan' => 'assets/icons/Property 1=makanan.png',
    'Transportasi' => 'assets/icons/Property 1=kendaraan.png',
    'Rumah' => 'assets/icons/Property 1=rumah.png',
    'Kesehatan' => 'assets/icons/Property 1=kesehatan.png',
    'Belanja' => 'assets/icons/Property 1=belanja.png',
    'Kecantikan' => 'assets/icons/Property 1=kecantikan.png',
    'Hiburan' => 'assets/icons/Property 1=hiburan.png',
    'Pendidikan' => 'assets/icons/Property 1=pendidikan.png',
    'Olahraga' => 'assets/icons/Property 1=olahraga.png',
    'Darurat' => 'assets/icons/Property 1=darurat.png',
    'Sedekah' => 'assets/icons/Property 1=sedekah.png',
    'Lainnya' => 'assets/icons/Property 1=lainnya.png',
    'Gaji' => 'assets/icons/Property 1=gaji.png',
    'Freelance' => 'assets/icons/Property 1=freelance.png',
    'Bisnis' => 'assets/icons/Property 1=bisnis.png',
    'Hadiah' => 'assets/icons/Property 1=hadiah.png',
    'Penjualan' => 'assets/icons/Property 1=penjualan.png',
    'Investasi' => 'assets/icons/Property 1=investasi.png',
    'Sewa' => 'assets/icons/Property 1=sewa.png',
    'Uang Saku' => 'assets/icons/Property 1=uangsaku.png',
    _ => null,
  };
}
