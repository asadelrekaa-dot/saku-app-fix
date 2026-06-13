import 'dart:io';

import 'dart:developer';

import 'dashboard_shared.dart';
import 'history_page.dart';

import '../../../core/repository/local_repository.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({
    super.key,
    required this.userName,
    this.photoUrl,
    required this.transactions,
    required this.onOpenHistory,
    required this.onOpenBudget,
    required this.onOpenInsight,
    required this.onMarkSettled,
  });

  final String userName;
  final String? photoUrl;
  final List<DashboardTransaction> transactions;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenBudget;
  final VoidCallback onOpenInsight;
  final ValueChanged<DashboardTransaction> onMarkSettled;

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _walletBalance = 0;
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
        _walletBalance = wallets.fold<int>(0, (sum, w) => sum + w.balance);
      });
    } catch (e, s) {
      log('[HomeDashboard] loadWalletBalance error', error: e, stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = widget.transactions;
    final totalBalance = transactions.fold<int>(
          0,
          (sum, item) => sum + item.amountValue,
        ) +
        _walletBalance;
    final expense = transactions
        .where((item) => item.amountValue < 0)
        .fold<int>(0, (sum, item) => sum + item.amountValue.abs());
    final income = transactions
        .where((item) => item.amountValue > 0)
        .fold<int>(0, (sum, item) => sum + item.amountValue);

    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        _HomeHeroSection(
          userName: widget.userName,
          photoUrl: widget.photoUrl,
          balance: totalBalance,
          expense: expense,
          income: income,
          onOpenBudget: widget.onOpenBudget,
          onOpenInsight: widget.onOpenInsight,
        ),
        _HomeBodyPanel(
          transactions: transactions,
          onOpenHistory: widget.onOpenHistory,
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
    required this.userName,
    this.photoUrl,
    required this.balance,
    required this.expense,
    required this.income,
    required this.onOpenBudget,
    required this.onOpenInsight,
  });

  final String userName;
  final String? photoUrl;
  final int balance;
  final int expense;
  final int income;
  final VoidCallback onOpenBudget;
  final VoidCallback onOpenInsight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 525,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 472,
            child: DecoratedBox(
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
          const Positioned(
            left: 0,
            right: 0,
            top: 418,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: SakuColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(46),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 36,
            child: _BalanceCard(
              userName: userName,
              photoUrl: photoUrl,
              balance: balance,
              expense: expense,
              income: income,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 388,
            child: _HeroTools(
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
    required this.transactions,
    required this.onOpenHistory,
    required this.debtTransactions,
    required this.onMarkSettled,
  });

  final List<DashboardTransaction> transactions;
  final VoidCallback onOpenHistory;
  final List<DashboardTransaction> debtTransactions;
  final ValueChanged<DashboardTransaction> onMarkSettled;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SakuColors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          _RecentNotesCard(
            transactions: transactions.take(2).toList(),
            onOpenMore: onOpenHistory,
          ),
          const SizedBox(height: 20),
          _ActiveDebtCard(
            debtTransactions: debtTransactions,
            onMarkSettled: onMarkSettled,
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.userName,
    this.photoUrl,
    required this.balance,
    required this.expense,
    required this.income,
  });

  final String userName;
  final String? photoUrl;
  final int balance;
  final int expense;
  final int income;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: SakuColors.blue900.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(28),
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
                radius: 24,
                backgroundColor: SakuColors.blue50,
                backgroundImage: photoUrl != null
                    ? (photoUrl!.startsWith('http')
                        ? NetworkImage(photoUrl!) as ImageProvider
                        : FileImage(File(photoUrl!)))
                    : null,
                child: photoUrl == null
                    ? const Icon(
                        Icons.person_rounded,
                        color: SakuColors.blue700,
                        size: 29,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Hei, $userName!',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SakuColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Total Saldo',
                  style: TextStyle(
                    color: SakuColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.visibility_outlined,
                color: SakuColors.white,
                size: 27,
              ),
            ],
          ),
          const SizedBox(height: 11),
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
                formatPlain(balance),
                style: const TextStyle(
                  color: SakuColors.neutral700,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
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
                    title: 'Pengeluaran',
                    amount: formatPlain(expense),
                    icon: Icons.trending_down_rounded,
                    color: SakuColors.danger,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HeroMetric(
                    title: 'Pemasukan',
                    amount: formatPlain(income),
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
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 21),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  amount,
                  style: const TextStyle(
                    color: SakuColors.black,
                    fontSize: 16,
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
    required this.onOpenBudget,
    required this.onOpenInsight,
  });

  final VoidCallback onOpenBudget;
  final VoidCallback onOpenInsight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 210,
              padding: const EdgeInsets.all(11),
              decoration: cardDecoration(radius: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ToolShortcut(
                      title: 'Budgeting',
                      icon: Icons.savings_rounded,
                      onTap: onOpenBudget,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ToolShortcut(
                      title: 'Saku Insight',
                      icon: Icons.insights_rounded,
                      onTap: onOpenInsight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            right: 2,
            bottom: -2,
            child: Image(
              image: AssetImage('assets/Maskot-dashboard.png'),
              width: 138,
              height: 88,
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
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: SakuColors.blue50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SakuColors.blue100, width: 2),
            ),
            child: Icon(icon, color: SakuColors.blue300, size: 30),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 13,
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
    required this.transactions,
    required this.onOpenMore,
  });

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
    final latestDate = transactions.isNotEmpty ? transactions.first.date : '';
    final totalDisplay = transactions.fold<int>(
      0,
      (sum, t) => sum + t.amountValue.abs(),
    );

    return Container(
      decoration: cardDecoration(radius: 18),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Catatan Terakhir',
                style: TextStyle(
                  color: SakuColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Container(
            color: SakuColors.blue50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(
              children: [
                Text(
                  _day(latestDate),
                  style: const TextStyle(
                    color: SakuColors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _month(latestDate),
                        style: const TextStyle(
                          color: SakuColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        _dayName(latestDate),
                        style: const TextStyle(
                          color: SakuColors.neutral300,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatPlain(totalDisplay),
                  style: const TextStyle(
                    color: SakuColors.neutral700,
                    fontSize: 17,
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
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                            fontSize: 16,
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
    required this.onMarkSettled,
  });

  final List<DashboardTransaction> debtTransactions;
  final ValueChanged<DashboardTransaction> onMarkSettled;

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
                  onMarkSettled: () => onMarkSettled(t),
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
    required this.onMarkSettled,
    this.settled = false,
  });

  final String title;
  final String person;
  final String amount;
  final String due;
  final VoidCallback onMarkSettled;
  final bool settled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onMarkSettled,
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
                onTap: onMarkSettled,
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


