import 'dart:math' as math;

import 'dashboard_shared.dart';
import 'dialog/category_sheet.dart';

enum _PeriodType { daily, weekly, monthly }

class ChartDashboard extends StatefulWidget {
  const ChartDashboard({super.key, required this.transactions});

  final List<DashboardTransaction> transactions;

  @override
  State<ChartDashboard> createState() => _ChartDashboardState();
}

class _ChartDashboardState extends State<ChartDashboard> {
  _PeriodType _period = _PeriodType.monthly;
  late DateTime _anchor;
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _anchor = _today;
  }

  /// Only outcome transactions.
  List<DashboardTransaction> get _outcomes {
    return widget.transactions.where((t) {
      if (t.apiType == 'outcome') return true;
      return t.amountValue < 0 && t.apiType == null;
    }).toList();
  }

  List<DashboardTransaction> get _filtered {
    final all = _outcomes.where((t) => t.rawDate != null).toList();
    final now = _anchor;
    return all.where((t) {
      final date = DateTime.tryParse(t.rawDate!);
      if (date == null) return false;
      switch (_period) {
        case _PeriodType.daily:
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        case _PeriodType.weekly:
          final weekStart = _weekStart(now);
          final weekEnd = weekStart.add(const Duration(days: 7));
          return !date.isBefore(weekStart) && date.isBefore(weekEnd);
        case _PeriodType.monthly:
          return date.year == now.year && date.month == now.month;
      }
    }).toList();
  }

  DateTime _weekStart(DateTime d) {
    final daysFromMonday = d.weekday - 1;
    return DateTime(d.year, d.month, d.day - daysFromMonday);
  }

  DateTime get _oneYearAgo =>
      DateTime(_today.year - 1, _today.month, _today.day);

  void _goBack() {
    setState(() {
      final prev = switch (_period) {
        _PeriodType.daily => _anchor.subtract(const Duration(days: 1)),
        _PeriodType.weekly => _anchor.subtract(const Duration(days: 7)),
        _PeriodType.monthly => DateTime(_anchor.year, _anchor.month - 1),
      };
      if (!prev.isBefore(_oneYearAgo)) {
        _anchor = prev;
      }
    });
  }

  void _goForward() {
    setState(() {
      final next = switch (_period) {
        _PeriodType.daily => _anchor.add(const Duration(days: 1)),
        _PeriodType.weekly => _anchor.add(const Duration(days: 7)),
        _PeriodType.monthly => DateTime(_anchor.year, _anchor.month + 1),
      };
      if (!next.isAfter(_today)) {
        _anchor = next;
      }
    });
  }

  bool get _canGoBack {
    final prev = switch (_period) {
      _PeriodType.daily => _anchor.subtract(const Duration(days: 1)),
      _PeriodType.weekly => _anchor.subtract(const Duration(days: 7)),
      _PeriodType.monthly => DateTime(_anchor.year, _anchor.month - 1),
    };
    return !prev.isBefore(_oneYearAgo);
  }

  bool get _canGoForward {
    final next = switch (_period) {
      _PeriodType.daily => _anchor.add(const Duration(days: 1)),
      _PeriodType.weekly => _anchor.add(const Duration(days: 7)),
      _PeriodType.monthly => DateTime(_anchor.year, _anchor.month + 1),
    };
    return !next.isAfter(_today);
  }

  String get _periodLabel {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    switch (_period) {
      case _PeriodType.daily:
        return '${_anchor.day} ${months[_anchor.month - 1]} ${_anchor.year}';
      case _PeriodType.weekly:
        final start = _weekStart(_anchor);
        final end = start.add(const Duration(days: 6));
        final sameMonth = start.month == end.month;
        if (sameMonth) {
          return '${start.day} - ${end.day} ${months[start.month - 1]} ${start.year}';
        }
        return '${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]} ${end.year}';
      case _PeriodType.monthly:
        return '${months[_anchor.month - 1]} ${_anchor.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        _TopBar(
          label: _periodLabel,
          onBack: _canGoBack ? _goBack : null,
          onForward: _canGoForward ? _goForward : null,
        ),
        const SizedBox(height: 12),
        _PeriodToggle(
          value: _period,
          onChanged: (p) => setState(() => _period = p),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _SummaryCard(
            total: filtered.fold<int>(0, (s, t) => s + t.amountValue.abs()),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _CategoryDonut(filtered: filtered),
        ),
      ],
    );
  }
}

// ── Top bar ──

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.label,
    required this.onBack,
    required this.onForward,
  });

  final String label;
  final VoidCallback? onBack;
  final VoidCallback? onForward;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SakuColors.blue100,
      padding: const EdgeInsets.fromLTRB(8, 22, 8, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded,
                color: SakuColors.blue900, size: 34),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded,
                color: SakuColors.blue900, size: 34),
            onPressed: onForward,
          ),
        ],
      ),
    );
  }
}

// ── Period toggle ──

class _PeriodToggle extends StatelessWidget {
  const _PeriodToggle({required this.value, required this.onChanged});

  final _PeriodType value;
  final ValueChanged<_PeriodType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ToggleChip(
          label: 'Harian',
          selected: value == _PeriodType.daily,
          onTap: () => onChanged(_PeriodType.daily),
        ),
        const SizedBox(width: 8),
        _ToggleChip(
          label: 'Mingguan',
          selected: value == _PeriodType.weekly,
          onTap: () => onChanged(_PeriodType.weekly),
        ),
        const SizedBox(width: 8),
        _ToggleChip(
          label: 'Bulanan',
          selected: value == _PeriodType.monthly,
          onTap: () => onChanged(_PeriodType.monthly),
        ),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? SakuColors.blue900 : SakuColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? SakuColors.blue900 : SakuColors.neutral300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? SakuColors.white : SakuColors.neutral600,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Total pengeluaran card ──

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SakuColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: SakuColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.trending_down_rounded,
              color: SakuColors.danger, size: 28),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Total Pengeluaran',
              style: TextStyle(
                fontSize: 16,
                color: SakuColors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            'Rp ${formatPlain(total)}',
            style: const TextStyle(
              fontSize: 18,
              color: SakuColors.danger,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Donut per kategori ──

class _CategoryDonut extends StatelessWidget {
  const _CategoryDonut({required this.filtered});

  final List<DashboardTransaction> filtered;

  static const _palette = [
    Color(0xFFFF355D),
    Color(0xFFF9EA18),
    Color(0xFFFFBE3D),
    Color(0xFFFF7D31),
    Color(0xFFE5007D),
    Color(0xFF5AC97B),
  ];

  List<ChartCategory> get _categories {
    final grouped = <String, int>{};
    for (final item in filtered) {
      grouped[item.title] =
          (grouped[item.title] ?? 0) + item.amountValue.abs();
    }
    if (grouped.isEmpty) {
      return const [
        ChartCategory(
          title: 'Belum ada',
          percent: 100,
          amountValue: 0,
          icon: Icons.pie_chart_outline_rounded,
          color: SakuColors.neutral300,
        ),
      ];
    }
    final total = grouped.values.fold<int>(0, (sum, value) => sum + value);
    var index = 0;
    return grouped.entries.map((entry) {
      final color = _palette[index % _palette.length];
      index += 1;
      return ChartCategory(
        title: entry.key,
        percent: math.max(1, ((entry.value / total) * 100).round()),
        amountValue: entry.value,
        icon: categoryIcon(entry.key),
        color: color,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    final total = categories.fold<int>(0, (s, e) => s + e.amountValue);

    return Container(
      decoration: cardDecoration(radius: 10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
            child: Row(
              children: [
                const Icon(Icons.pie_chart_outline_rounded,
                    color: SakuColors.black, size: 28),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Pengeluaran',
                    style: TextStyle(
                      color: SakuColors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: SakuColors.neutral100),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 26),
            child: SizedBox(
              height: 230,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(210, 210),
                    painter: _DonutChartPainter(categories),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: SakuColors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatPlain(total),
                        style: const TextStyle(
                          color: SakuColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ...categories.take(4).map((cat) => _CategoryRow(cat)),
          if (categories.length > 4)
            Material(
              color: SakuColors.neutral100,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: SakuColors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    builder: (context) => CategorySheet(
                      categories: categories,
                    ),
                  );
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lihat Lainnya',
                        style: TextStyle(
                          color: SakuColors.neutral600,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: SakuColors.neutral600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}



class _CategoryRow extends StatelessWidget {
  const _CategoryRow(this.category);

  final ChartCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: SakuColors.neutral100)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: category.color,
            child: Icon(category.icon, color: SakuColors.black, size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category.title,
              style: const TextStyle(
                color: SakuColors.neutral700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '${category.percent}%',
            style: const TextStyle(
              color: SakuColors.neutral700,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}


class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter(this.categories);

  final List<ChartCategory> categories;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 48
      ..strokeCap = StrokeCap.butt;

    var startAngle = -math.pi / 2;
    final total = categories.fold<int>(0, (sum, item) => sum + item.percent);

    for (final category in categories) {
      final sweepAngle = math.pi * 2 * (category.percent / total);
      paint.color = category.color;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.categories != categories;
  }
}
