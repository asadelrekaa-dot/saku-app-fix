import 'dart:io';

import 'dart:developer';

import 'dialog/wallet_picker_sheet.dart';
import 'dashboard_shared.dart';
import 'history_page.dart';

import '../../../core/repository/local_repository.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({
    super.key,
    required this.userName,
    this.photoUrl,
    required this.transactions,
    required this.budgets,
    required this.onOpenHistory,
    required this.onOpenBudget,
    required this.onOpenInsight,
    required this.onMarkSettled,
  });

  final String userName;
  final String? photoUrl;
  final List<DashboardTransaction> transactions;
  final List<DashboardBudget> budgets;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenBudget;
  final VoidCallback onOpenInsight;
  final void Function(DashboardTransaction item, int walletId) onMarkSettled;

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _walletBalance = 0;
  List<WalletItem> _wallets = [];
  final _repo = const LocalRepository();

  @override
  void initState() {
    super.initState();
    _loadWalletBalance();
  }

  @override
  void didUpdateWidget(HomeDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transactions != oldWidget.transactions) {
      _loadWalletBalance();
    }
  }

  Future<void> _loadWalletBalance() async {
    try {
      final wallets = await _repo.loadWallets();
      if (!mounted) return;
      setState(() {
        _wallets = wallets;
        _walletBalance = wallets.fold<int>(0, (sum, w) => sum + w.balance);
      });
    } catch (e, s) {
      log('[HomeDashboard] loadWalletBalance error', error: e, stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 380;
    final transactions = widget.transactions;
    final totalBalance = _walletBalance;
    final expense = transactions
        .where((item) => item.amountValue < 0)
        .fold<int>(0, (sum, item) => sum + item.amountValue.abs());
    final income = transactions
        .where((item) => item.amountValue > 0)
        .fold<int>(0, (sum, item) => sum + item.amountValue);

    return ListView(
      padding: EdgeInsets.only(bottom: isSmall ? 80 : 96),
      children: [
        _HomeHeroSection(
          isSmall: isSmall,
          userName: widget.userName,
          photoUrl: widget.photoUrl,
          balance: totalBalance,
          expense: expense,
          income: income,
          onOpenBudget: widget.onOpenBudget,
          onOpenInsight: widget.onOpenInsight,
        ),
        _HomeBodyPanel(
          isSmall: isSmall,
          transactions: transactions,
          budgets: widget.budgets,
          wallets: _wallets,
          onOpenHistory: widget.onOpenHistory,
          onOpenBudget: widget.onOpenBudget,
          debtTransactions: transactions.where((t) =>
              (t.title == 'Hutang' || t.title == 'Beri Pinjaman') &&
              !t.settled).toList(),
          onMarkSettled: widget.onMarkSettled,
        ),
      ],
    );
  }
}

class _HomeHeroSection extends StatelessWidget {
  const _HomeHeroSection({
    required this.isSmall,
    required this.userName,
    this.photoUrl,
    required this.balance,
    required this.expense,
    required this.income,
    required this.onOpenBudget,
    required this.onOpenInsight,
  });

  final bool isSmall;
  final String userName;
  final String? photoUrl;
  final int balance;
  final int expense;
  final int income;
  final VoidCallback onOpenBudget;
  final VoidCallback onOpenInsight;

  @override
  Widget build(BuildContext context) {
    final heroH = isSmall ? 460 : 525;
    final slabH = isSmall ? 410 : 472;
    final curveTop = isSmall ? 360 : 418;
    final cardTop = isSmall ? 28.0 : 36.0;
    final toolsTop = isSmall ? 338.0 : 388.0;
    final hMargin = isSmall ? 16.0 : 20.0;
    final curveRadius = isSmall ? 36.0 : 46.0;

    return SizedBox(
      height: heroH.toDouble(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: slabH.toDouble(),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: SakuColors.blue100,
                image: DecorationImage(
                  image: AssetImage('assets/background beranda biru.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: curveTop.toDouble(),
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: SakuColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(curveRadius),
                ),
              ),
            ),
          ),
          Positioned(
            left: hMargin,
            right: hMargin,
            top: cardTop,
            child: _BalanceCard(
              isSmall: isSmall,
              userName: userName,
              photoUrl: photoUrl,
              balance: balance,
              expense: expense,
              income: income,
            ),
          ),
          Positioned(
            left: hMargin,
            right: hMargin,
            top: toolsTop,
            child: _HeroTools(
              isSmall: isSmall,
              onOpenBudget: onOpenBudget,
              onOpenInsight: onOpenInsight,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBodyPanel extends StatelessWidget {
  const _HomeBodyPanel({
    required this.isSmall,
    required this.transactions,
    required this.budgets,
    required this.onOpenHistory,
    required this.onOpenBudget,
    required this.debtTransactions,
    required this.wallets,
    required this.onMarkSettled,
  });

  final bool isSmall;
  final List<DashboardTransaction> transactions;
  final List<DashboardBudget> budgets;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenBudget;
  final List<DashboardTransaction> debtTransactions;
  final List<WalletItem> wallets;
  final void Function(DashboardTransaction item, int walletId) onMarkSettled;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SakuColors.white,
      padding: EdgeInsets.fromLTRB(isSmall ? 16 : 20, 0, isSmall ? 16 : 20, 0),
      child: Column(
        children: [
          _RecentNotesCard(
            isSmall: isSmall,
            transactions: transactions.take(2).toList(),
            onOpenMore: onOpenHistory,
          ),
          SizedBox(height: isSmall ? 16 : 20),
          if (budgets.isNotEmpty) ...[
            _BudgetRingkasanCard(budgets: budgets, onTap: onOpenBudget),
            SizedBox(height: isSmall ? 16 : 20),
          ] else ...[
            _CreateBudgetCard(onTap: onOpenBudget),
            SizedBox(height: isSmall ? 16 : 20),
          ],
          _ActiveDebtCard(
            debtTransactions: debtTransactions,
            wallets: wallets,
            onMarkSettled: onMarkSettled,
          ),
        ],
      ),
    );
  }
}

class _CreateBudgetCard extends StatelessWidget {
  const _CreateBudgetCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SakuColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SakuColors.blue100, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: SakuColors.blue50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_chart_rounded,
                  color: SakuColors.blue700, size: 22),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Buat batas pengeluaran per kategori',
                style: TextStyle(
                  color: SakuColors.blue700,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: SakuColors.blue300, size: 24),
          ],
        ),
      ),
    );
  }
}

class _BudgetRingkasanCard extends StatelessWidget {
  const _BudgetRingkasanCard({required this.budgets, this.onTap});

  final List<DashboardBudget> budgets;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SakuColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SakuColors.neutral100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.savings_rounded, color: SakuColors.mango500, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Ringkasan Budget',
                    style: TextStyle(
                      color: SakuColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: SakuColors.neutral300, size: 22),
              ],
            ),
            const SizedBox(height: 12),
            ...budgets.take(3).map((b) => _MiniBudgetRow(b)),
            if (budgets.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${budgets.length - 3} budget lainnya',
                  style: const TextStyle(
                    color: SakuColors.neutral300,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniBudgetRow extends StatelessWidget {
  const _MiniBudgetRow(this.item);

  final DashboardBudget item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(item.icon, size: 18, color: SakuColors.blue700),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: SakuColors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Rp ${formatPlain(item.amountValue)}',
                      style: const TextStyle(
                        color: SakuColors.neutral600,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: item.progress,
                          minHeight: 8,
                          color: item.progress >= 0.8
                              ? SakuColors.danger
                              : SakuColors.mango500,
                          backgroundColor: SakuColors.neutral100,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.remaining,
                      style: TextStyle(
                        color: item.progress >= 0.8
                            ? SakuColors.danger
                            : SakuColors.neutral300,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatefulWidget {
  const _BalanceCard({
    required this.isSmall,
    required this.userName,
    this.photoUrl,
    required this.balance,
    required this.expense,
    required this.income,
  });

  final bool isSmall;
  final String userName;
  final String? photoUrl;
  final int balance;
  final int expense;
  final int income;

  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard> {
  bool _showBalance = true;

  @override
  Widget build(BuildContext context) {
    final s = widget.isSmall;
    return Container(
      padding: EdgeInsets.fromLTRB(s ? 16 : 22, s ? 16 : 22, s ? 16 : 22, s ? 14 : 20),
      decoration: BoxDecoration(
        color: SakuColors.blue900.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(s ? 22 : 28),
        boxShadow: [
          BoxShadow(
            color: SakuColors.blue900.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: s ? 20 : 24,
                backgroundColor: SakuColors.blue50,
                backgroundImage: widget.photoUrl != null
                    ? (widget.photoUrl!.startsWith('http')
                        ? NetworkImage(widget.photoUrl!) as ImageProvider
                        : FileImage(File(widget.photoUrl!)))
                    : null,
                child: widget.photoUrl == null
                    ? Icon(
                        Icons.person_rounded,
                        color: SakuColors.blue700,
                        size: s ? 24 : 29,
                      )
                    : null,
              ),
              SizedBox(width: s ? 10 : 12),
              Expanded(
                child: Text(
                  'Hei, ${widget.userName}!',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: SakuColors.white,
                    fontSize: s ? 17 : 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: s ? 16 : 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Saldo',
                  style: TextStyle(
                    color: SakuColors.white,
                    fontSize: s ? 14 : 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showBalance = !_showBalance),
                child: Icon(
                  _showBalance
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: SakuColors.white,
                  size: s ? 23 : 27,
                ),
              ),
            ],
          ),
          SizedBox(height: s ? 9 : 11),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              color: SakuColors.blue100,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: SakuColors.blue300, width: 2),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _showBalance
                    ? formatPlain(widget.balance)
                    : 'Rp *** ***',
                style: TextStyle(
                  color: SakuColors.neutral700,
                  fontSize: s ? 20 : 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(height: s ? 10 : 13),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: SakuColors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: SakuColors.blue300, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _HeroMetric(
                    isSmall: s,
                    title: 'Pengeluaran',
                    amount: formatPlain(widget.expense),
                    icon: Icons.trending_down_rounded,
                    color: SakuColors.danger,
                  ),
                ),
                SizedBox(width: s ? 8 : 10),
                Expanded(
                  child: _HeroMetric(
                    isSmall: s,
                    title: 'Pemasukan',
                    amount: formatPlain(widget.income),
                    icon: Icons.trending_up_rounded,
                    color: SakuColors.success,
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

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.isSmall,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final bool isSmall;
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: isSmall ? 18 : 21),
        SizedBox(width: isSmall ? 5 : 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: SakuColors.black,
                  fontSize: isSmall ? 10 : 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  amount,
                  style: TextStyle(
                    color: SakuColors.black,
                    fontSize: isSmall ? 14 : 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroTools extends StatelessWidget {
  const _HeroTools({
    required this.isSmall,
    required this.onOpenBudget,
    required this.onOpenInsight,
  });

  final bool isSmall;
  final VoidCallback onOpenBudget;
  final VoidCallback onOpenInsight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isSmall ? 96 : 108,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: isSmall ? 175 : 210,
              padding: const EdgeInsets.all(11),
              decoration: cardDecoration(radius: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ToolShortcut(
                      isSmall: isSmall,
                      title: 'Budgeting',
                      icon: Icons.savings_rounded,
                      onTap: onOpenBudget,
                    ),
                  ),
                  SizedBox(width: isSmall ? 8 : 10),
                  Expanded(
                    child: _ToolShortcut(
                      isSmall: isSmall,
                      title: 'Saku Insight',
                      icon: Icons.insights_rounded,
                      onTap: onOpenInsight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 2,
            bottom: -2,
            child: Image(
              image: const AssetImage('assets/Maskot-dashboard.png'),
              width: isSmall ? 110 : 138,
              height: isSmall ? 70 : 88,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolShortcut extends StatelessWidget {
  const _ToolShortcut({
    required this.isSmall,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final bool isSmall;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconSize = isSmall ? 44.0 : 52.0;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: SakuColors.blue50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SakuColors.blue100, width: 2),
            ),
            child: Icon(icon, color: SakuColors.blue300, size: isSmall ? 24 : 30),
          ),
          SizedBox(height: isSmall ? 5 : 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                color: SakuColors.black,
                fontSize: isSmall ? 11 : 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentNotesCard extends StatelessWidget {
  const _RecentNotesCard({
    required this.isSmall,
    required this.transactions,
    required this.onOpenMore,
  });

  final bool isSmall;
  final List<DashboardTransaction> transactions;
  final VoidCallback onOpenMore;

  String _day(String dateStr) {
    final parts = dateStr.split(' ');
    return parts.isNotEmpty ? parts[0] : '';
  }

  String _month(String dateStr) {
    final parts = dateStr.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }

  String _dayName(String dateStr) {
    final parsed = _tryParseDate(dateStr);
    if (parsed == null) return '';
    const days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    return days[parsed.weekday - 1];
  }

  DateTime? _tryParseDate(String dateStr) {
    try {
      const months = {
        'Januari': 1, 'Februari': 2, 'Maret': 3, 'April': 4,
        'Mei': 5, 'Juni': 6, 'Juli': 7, 'Agustus': 8,
        'September': 9, 'Oktober': 10, 'November': 11, 'Desember': 12
      };
      final parts = dateStr.split(' ');
      if (parts.length < 3) return null;
      final day = int.tryParse(parts[0]);
      final month = months[parts[1]];
      final year = int.tryParse(parts[2]);
      if (day == null || month == null || year == null) return null;
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = isSmall;
    final latestDate = transactions.isNotEmpty ? transactions.first.date : '';
    final totalDisplay = transactions.fold<int>(
      0,
      (sum, t) => sum + t.amountValue.abs(),
    );

    return Container(
      decoration: cardDecoration(radius: 18),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(s ? 14 : 16, s ? 12 : 14, s ? 14 : 16, s ? 6 : 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Catatan Terakhir',
                style: TextStyle(
                  color: SakuColors.black,
                  fontSize: s ? 16 : 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Container(
            color: SakuColors.blue50,
            padding: EdgeInsets.symmetric(horizontal: s ? 14 : 16, vertical: s ? 9 : 11),
            child: Row(
              children: [
                Text(
                  _day(latestDate),
                  style: TextStyle(
                    color: SakuColors.black,
                    fontSize: s ? 26 : 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: s ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _month(latestDate),
                        style: TextStyle(
                          color: SakuColors.black,
                          fontSize: s ? 16 : 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        _dayName(latestDate),
                        style: TextStyle(
                          color: SakuColors.neutral300,
                          fontSize: s ? 13 : 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatPlain(totalDisplay),
                  style: TextStyle(
                    color: SakuColors.neutral700,
                    fontSize: s ? 15 : 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          ...transactions.map((transaction) => TransactionTile(
                item: transaction,
                compactIcon: true,
              )),
          Material(
            color: SakuColors.neutral100,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
            child: InkWell(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
              onTap: onOpenMore,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: s ? 14 : 16, vertical: s ? 12 : 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Lihat riwayat lainnya',
                          style: TextStyle(
                            color: SakuColors.neutral600,
                            fontSize: s ? 14 : 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: SakuColors.neutral600,
                      size: 30,
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

class _ActiveDebtCard extends StatelessWidget {
  const _ActiveDebtCard({
    required this.debtTransactions,
    required this.wallets,
    required this.onMarkSettled,
  });

  final List<DashboardTransaction> debtTransactions;
  final List<WalletItem> wallets;
  final void Function(DashboardTransaction item, int walletId) onMarkSettled;

  String _personName(DashboardTransaction t) {
    final cleaned = t.note
        .replaceFirst(RegExp(r'^Pinjaman ke\s+', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^Hutang ke\s+', caseSensitive: false), '')
        .trim();
    return cleaned.isEmpty ? 'Nama' : cleaned;
  }

  @override
  Widget build(BuildContext context) {
    if (debtTransactions.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: cardDecoration(radius: 18),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hutang Aktif',
            style: TextStyle(
              color: SakuColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(debtTransactions.length, (index) {
            final t = debtTransactions[index];
            return Column(
              children: [
                if (index > 0)
                  const Divider(height: 1, color: SakuColors.neutral100),
                _DebtTile(
                  title: t.title,
                  person: _personName(t),
                  amount: formatPlain(t.amountValue.abs()),
                  due: t.date,
                  settled: t.settled,
                  wallets: wallets,
                  onSettle: (walletId) => onMarkSettled(t, walletId),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _DebtTile extends StatelessWidget {
  const _DebtTile({
    required this.title,
    required this.person,
    required this.amount,
    required this.due,
    required this.wallets,
    required this.onSettle,
    this.settled = false,
  });

  final String title;
  final String person;
  final String amount;
  final String due;
  final List<WalletItem> wallets;
  final ValueChanged<int> onSettle;
  final bool settled;

  void _handleTap(BuildContext context) {
    if (wallets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada dompet. Buat dompet di halaman Profil.')),
      );
      return;
    }
    showModalBottomSheet<int>(
      context: context,
      builder: (ctx) => WalletPickerSheet(
        wallets: wallets,
        selectedId: wallets.first.id,
        onSelected: (id, name) {
          Navigator.of(ctx).pop();
          onSettle(id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleTap(context),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: settled ? SakuColors.success.withValues(alpha: 0.1) : SakuColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: settled ? SakuColors.success : SakuColors.neutral300,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  settled ? Icons.check_circle_rounded : Icons.payments_outlined,
                  color: settled ? SakuColors.success : SakuColors.sage500,
                  size: 25,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: title,
                        style: TextStyle(
                          color: settled ? SakuColors.neutral300 : SakuColors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                        children: [
                          TextSpan(
                            text: settled ? ' Lunas' : ' Belum Lunas',
                            style: TextStyle(
                              color: settled ? SakuColors.success : SakuColors.danger,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$person - ${title == 'Beri Pinjaman' ? 'minjam uang' : 'utang'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: settled ? SakuColors.neutral100 : SakuColors.neutral300,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 82,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        amount,
                        style: TextStyle(
                          color: settled ? SakuColors.neutral300 : SakuColors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        due,
                        style: TextStyle(
                          color: settled ? SakuColors.neutral100 : SakuColors.neutral300,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _handleTap(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: settled ? SakuColors.success : SakuColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: settled ? SakuColors.success : SakuColors.neutral300,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    settled ? Icons.check_rounded : Icons.check_rounded,
                    color: settled ? SakuColors.white : SakuColors.neutral300,
                    size: 21,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


