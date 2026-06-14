import '../../../core/repository/local_repository.dart';
import 'dashboard_shared.dart';
import 'dialog/filter_dialog.dart';
import 'dialog/transaction_detail_dialog.dart';

class HistoryDashboard extends StatefulWidget {
  const HistoryDashboard({
    super.key,
    required this.transactions,
    required this.onDelete,
    required this.onEdit,
    required this.onMarkSettled,
  });

  final List<DashboardTransaction> transactions;
  final ValueChanged<DashboardTransaction> onDelete;
  final ValueChanged<DashboardTransaction> onEdit;
  final void Function(DashboardTransaction item, int walletId) onMarkSettled;

  @override
  State<HistoryDashboard> createState() => HistoryDashboardState();
}

class HistoryDashboardState extends State<HistoryDashboard> {
  String _query = '';
  String _category = 'Semua';
  late int _selectedMonth;
  late int _selectedYear;
  List<WalletItem> _wallets = [];
  final _repo = const LocalRepository();

  @override
  void initState() {
    super.initState();
    _initMonthFromLatest();
    _loadWallets();
  }

  Future<void> _loadWallets() async {
    final wallets = await _repo.loadWallets();
    if (!mounted) return;
    setState(() => _wallets = wallets);
  }

  @override
  void didUpdateWidget(HistoryDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transactions != oldWidget.transactions) {
      _initMonthFromLatest();
    }
  }

  void _initMonthFromLatest() {
    final latest = widget.transactions.isNotEmpty ? widget.transactions.first : null;
    if (latest != null) {
      final parsed = _parseDate(latest.rawDate, latest.date);
      if (parsed != null) {
        _selectedMonth = parsed.month;
        _selectedYear = parsed.year;
        return;
      }
    }
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
  }

  DateTime? _parseDate(String? rawDate, String dateStr) {
    if (rawDate != null) {
      final parsed = DateTime.tryParse(rawDate);
      if (parsed != null) return parsed;
    }
    if (dateStr.isNotEmpty && dateStr != '—') {
      const months = {
        'Januari': 1, 'Februari': 2, 'Maret': 3, 'April': 4,
        'Mei': 5, 'Juni': 6, 'Juli': 7, 'Agustus': 8,
        'September': 9, 'Oktober': 10, 'November': 11, 'Desember': 12,
      };
      final parts = dateStr.split(' ');
      if (parts.length >= 3) {
        final day = int.tryParse(parts[0]);
        final month = months[parts[1]];
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }
    }
    return null;
  }

  bool _matchesMonth(DashboardTransaction item) {
    final parsed = _parseDate(item.rawDate, item.date);
    if (parsed == null) return false;
    return parsed.month == _selectedMonth && parsed.year == _selectedYear;
  }

  void _goToPrevMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear -= 1;
      } else {
        _selectedMonth -= 1;
      }
    });
  }

  void _goToNextMonth() {
    final now = DateTime.now();
    final nextMonth = _selectedMonth == 12 ? 1 : _selectedMonth + 1;
    final nextYear = _selectedMonth == 12 ? _selectedYear + 1 : _selectedYear;
    if (nextYear > now.year || (nextYear == now.year && nextMonth > now.month)) return;
    setState(() {
      _selectedMonth = nextMonth;
      _selectedYear = nextYear;
    });
  }

  bool get _canGoBack {
    final prevYear = _selectedMonth == 1 ? _selectedYear - 1 : _selectedYear;
    return prevYear >= 2020;
  }

  bool get _canGoForward {
    final now = DateTime.now();
    return _selectedYear < now.year || (_selectedYear == now.year && _selectedMonth < now.month);
  }



  String _monthNameFor(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  List<DashboardTransaction> get _visibleTransactions {
    return widget.transactions.where((item) {
      final matchesQuery = _query.trim().isEmpty ||
          item.title.toLowerCase().contains(_query.toLowerCase()) ||
          item.note.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _category == 'Semua' || item.title == _category;
      final matchesMonth = _matchesMonth(item);
      return matchesQuery && matchesCategory && matchesMonth;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleTransactions = _visibleTransactions;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      children: [
        const Text(
          'Riwayat',
          style: TextStyle(
            color: SakuColors.black,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Cari catatan...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => FilterDialog(
                    selectedCategory: _category,
                    onApply: (category) {
                      setState(() => _category = category);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.filter_alt_rounded),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _MonthHeader(
          month: _monthNameFor(_selectedMonth),
          year: _selectedYear.toString(),
          onBack: _canGoBack ? _goToPrevMonth : null,
          onForward: _canGoForward ? _goToNextMonth : null,
        ),
        const SizedBox(height: 14),
        if (visibleTransactions.isEmpty)
          const EmptyStateCard(
            icon: Icons.receipt_long_outlined,
            title: 'Belum ada catatan',
            message: 'Coba ubah pencarian atau filter kategorinya.',
          )
        else
          _CardList(
            children: visibleTransactions
                .map(
                  (transaction) => TransactionTile(
                    item: transaction,
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => TransactionDetailDialog(
                          item: transaction,
                          wallets: _wallets,
                          onDelete: () {
                            widget.onDelete(transaction);
                            Navigator.of(context).pop();
                          },
                          onMarkSettled: (walletId) {
                            widget.onMarkSettled(transaction, walletId);
                            Navigator.of(context).pop();
                          },
                          onEdit: () {
                            Navigator.of(context).pop();
                            widget.onEdit(transaction);
                          },
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}



class _CardList extends StatelessWidget {
  const _CardList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(),
      child: Column(children: children),
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.item,
    this.compactIcon = false,
    this.onTap,
  });

  final DashboardTransaction item;
  final bool compactIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: compactIcon
                      ? SakuColors.white
                      : item.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(compactIcon ? 12 : 14),
                  border: compactIcon
                      ? Border.all(color: SakuColors.neutral300, width: 1.5)
                      : null,
                ),
                child: Icon(item.icon, color: item.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: SakuColors.black,
                        fontSize: compactIcon ? 20 : 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: SakuColors.neutral300),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.amount,
                    style: TextStyle(
                      color: item.color,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!compactIcon) ...[
                    Text(
                      item.date,
                      style: const TextStyle(
                        color: SakuColors.neutral600,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    item.time,
                    style: const TextStyle(
                      color: SakuColors.neutral300,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.year,
    this.onBack,
    this.onForward,
  });

  final String month;
  final String year;
  final VoidCallback? onBack;
  final VoidCallback? onForward;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SakuColors.blue100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: SakuColors.blue900),
            onPressed: onBack,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  month,
                  style: const TextStyle(
                    color: SakuColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  year,
                  style: const TextStyle(
                    color: SakuColors.neutral700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: SakuColors.blue900),
            onPressed: onForward,
          ),
        ],
      ),
    );
  }
}
