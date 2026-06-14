import 'package:flutter/material.dart';

import '../../../../core/models/dashboard_models.dart';
import '../dashboard_shared.dart';

class LoanDetailDialog extends StatelessWidget {
  const LoanDetailDialog({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onEdit,
    required this.onMarkSettled,
  });

  final DashboardTransaction item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onMarkSettled;

  @override
  Widget build(BuildContext context) {
    final person = _loanPersonName(item.note);
    final note = _loanNote(item.note, person);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
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
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Beri Pinjaman',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: SakuColors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          PaidBadge(settled: item.settled),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 118,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Rp ${formatPlain(item.amountValue.abs())}',
                          maxLines: 1,
                          style: const TextStyle(
                            color: SakuColors.neutral300,
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Icon(
                      Icons.hourglass_bottom_rounded,
                      color: SakuColors.neutral300,
                      size: 15,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '30 April 2026',
                      style: TextStyle(
                        color: SakuColors.neutral300,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const DashedSeparator(),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama',
                            style: TextStyle(
                              color: SakuColors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            person.isEmpty ? 'Nama' : person,
                            style: const TextStyle(
                              color: SakuColors.neutral300,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Catatan',
                            style: TextStyle(
                              color: SakuColors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                          ),
                          Text(
                            note,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: SakuColors.neutral300,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Dompet',
                          style: TextStyle(
                            color: SakuColors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(height: 8),
                        LoanWalletIcon(),
                      ],
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
                IconButton(
                  tooltip: 'Hapus',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_rounded, color: Colors.red),
                ),
                IconButton(
                  tooltip: 'Edit',
                  onPressed: onEdit,
                  icon:
                      const Icon(Icons.edit_rounded, color: SakuColors.blue700),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Tandai lunas',
                  onPressed: onMarkSettled,
                  icon: Icon(
                    Icons.check_rounded,
                    color: item.settled ? SakuColors.neutral300 : Colors.green,
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

  String _loanPersonName(String source) {
    final cleaned = source
        .replaceFirst(RegExp(r'^Pinjaman ke\s+', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^Minjam uang ke\s+', caseSensitive: false), '')
        .trim();
    return cleaned.isEmpty ? 'Anisa' : cleaned;
  }

  String _loanNote(String source, String person) {
    final lower = source.toLowerCase();
    if (source.trim().isEmpty || lower.startsWith('pinjaman ke')) {
      return 'Minjam uang ke\n${person.toLowerCase()}';
    }
    return source;
  }
}

class PaidBadge extends StatelessWidget {
  const PaidBadge({super.key, required this.settled});

  final bool settled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: settled ? const Color(0xFFD9FBE8) : SakuColors.neutral100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: settled ? SakuColors.success : SakuColors.neutral300,
        ),
      ),
      child: Text(
        settled ? 'Lunas' : 'Belum Lunas',
        style: TextStyle(
          color: settled ? SakuColors.success : SakuColors.neutral600,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class DashedSeparator extends StatelessWidget {
  const DashedSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 18.0;
        const gap = 12.0;
        final count = (constraints.maxWidth / (dashWidth + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            count,
            (index) => Container(
              width: dashWidth,
              height: 3,
              margin: EdgeInsets.only(right: index == count - 1 ? 0 : gap),
              decoration: BoxDecoration(
                color: SakuColors.neutral300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LoanWalletIcon extends StatelessWidget {
  const LoanWalletIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 31,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 1,
            top: 2,
            child: Container(
              width: 22,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFE09B33),
                border: Border.all(color: SakuColors.black, width: 1.4),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            left: 3,
            top: 5,
            child: Container(
              width: 25,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFFFC14E),
                border: Border.all(color: SakuColors.black, width: 1.4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(
                    Icons.circle,
                    color: SakuColors.mango500,
                    size: 6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
