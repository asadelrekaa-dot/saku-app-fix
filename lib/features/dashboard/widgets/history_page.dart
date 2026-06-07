import 'dashboard_shared.dart';
import 'add_note_page.dart';

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
  final ValueChanged<DashboardTransaction> onMarkSettled;

  @override
  State<HistoryDashboard> createState() => HistoryDashboardState();
}

class HistoryDashboardState extends State<HistoryDashboard> {
  String _query = '';
  String _category = 'Semua';

  List<DashboardTransaction> get _visibleTransactions {
    return widget.transactions.where((item) {
      final matchesQuery = _query.trim().isEmpty ||
          item.title.toLowerCase().contains(_query.toLowerCase()) ||
          item.note.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _category == 'Semua' || item.title == _category;
      return matchesQuery && matchesCategory;
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
                  builder: (context) => _FilterDialog(
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
        const _MonthHeader(),
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
                        builder: (context) => _TransactionDetailDialog(
                          item: transaction,
                          onDelete: () {
                            widget.onDelete(transaction);
                            Navigator.of(context).pop();
                          },
                          onMarkSettled: () {
                            widget.onMarkSettled(transaction);
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

class _FilterDialog extends StatefulWidget {
  const _FilterDialog({
    required this.selectedCategory,
    required this.onApply,
  });

  final String selectedCategory;
  final ValueChanged<String> onApply;

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late String _category = widget.selectedCategory;

  void _pickCategory() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: SakuColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => CategoryPickerSheet(
        selectedCategory: _category,
        kind: CategoryKind.expense,
        includeAll: true,
        onSelected: (category) {
          setState(() => _category = category);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cari berdasarkan filter\ntanggal dan kategori',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 17,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DialogSelectField(
                    label: 'Kategori',
                    value: _category == 'Semua' ? 'Semua' : _category,
                    icon: Icons.work_rounded,
                    trailing: Icons.chevron_right_rounded,
                    muted: _category == 'Semua',
                    onTap: _pickCategory,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: DialogSelectField(
                    label: 'Tanggal',
                    value: 'Pilih tanggal',
                    icon: null,
                    trailing: Icons.keyboard_arrow_down_rounded,
                    muted: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SakuColors.mango500,
                      side: const BorderSide(
                        color: SakuColors.mango500,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: FilledButton(
                    onPressed: () => widget.onApply(_category),
                    style: FilledButton.styleFrom(
                      backgroundColor: SakuColors.blue300,
                      foregroundColor: SakuColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Cari',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionDetailDialog extends StatelessWidget {
  const _TransactionDetailDialog({
    required this.item,
    required this.onDelete,
    required this.onEdit,
    required this.onMarkSettled,
  });

  final DashboardTransaction item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onMarkSettled;

  bool get _isLoan => item.title == 'Beri Pinjaman';
  bool get _isDebt => item.title == 'Hutang';

  @override
  Widget build(BuildContext context) {
    if (_isLoan) {
      return _LoanDetailDialog(
        item: item,
        onDelete: onDelete,
        onEdit: onEdit,
        onMarkSettled: onMarkSettled,
      );
    }

    if (_isDebt) {
      return _DebtPaymentDialog(
        item: item,
        onMarkSettled: onMarkSettled,
      );
    }

    return _StandardTransactionDetailDialog(
      item: item,
      onDelete: onDelete,
      onEdit: onEdit,
    );
  }
}

class _StandardTransactionDetailDialog extends StatelessWidget {
  const _StandardTransactionDetailDialog({
    required this.item,
    required this.onDelete,
    required this.onEdit,
  });

  final DashboardTransaction item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

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
                const _DashedSeparator(),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _TransactionDetailColumn(
                        label: 'Catatan',
                        value: item.note,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const _TransactionDetailColumn(
                      label: 'Cash',
                      alignment: CrossAxisAlignment.center,
                      child: _LoanWalletIcon(),
                    ),
                    const SizedBox(width: 18),
                    _TransactionDetailColumn(
                      label: item.title,
                      alignment: CrossAxisAlignment.center,
                      child: _CategoryDetailIcon(
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

class _TransactionDetailColumn extends StatelessWidget {
  const _TransactionDetailColumn({
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

class _CategoryDetailIcon extends StatelessWidget {
  const _CategoryDetailIcon({
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
      return Image.asset(
        assetPath!,
        width: 34,
        height: 34,
        fit: BoxFit.contain,
      );
    }

    return Icon(icon, color: color, size: 32);
  }
}

class _DebtPaymentDialog extends StatelessWidget {
  const _DebtPaymentDialog({
    required this.item,
    required this.onMarkSettled,
  });

  final DashboardTransaction item;
  final VoidCallback onMarkSettled;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bayar hutang dari dompet mana?',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: DialogSelectField(
                    label: 'Dompet',
                    value: 'BSI',
                    icon: Icons.credit_card_rounded,
                    trailing: Icons.keyboard_arrow_down_rounded,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DialogSelectField(
                    label: 'Tanggal Lunas',
                    value: '12 Juni 2026',
                    icon: null,
                    trailing: Icons.calendar_month_rounded,
                    muted: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SakuColors.mango500,
                      side: const BorderSide(
                        color: SakuColors.mango500,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: onMarkSettled,
                    style: FilledButton.styleFrom(
                      backgroundColor: item.settled
                          ? SakuColors.success
                          : SakuColors.neutral300,
                      foregroundColor: item.settled
                          ? SakuColors.white
                          : SakuColors.neutral600,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      item.settled ? 'Sudah Lunas' : 'Lunas',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanDetailDialog extends StatelessWidget {
  const _LoanDetailDialog({
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
                          _PaidBadge(settled: item.settled),
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
                const _DashedSeparator(),
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
                          'Cash',
                          style: TextStyle(
                            color: SakuColors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(height: 8),
                        _LoanWalletIcon(),
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

class _PaidBadge extends StatelessWidget {
  const _PaidBadge({required this.settled});

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

class _DashedSeparator extends StatelessWidget {
  const _DashedSeparator();

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

class _LoanWalletIcon extends StatelessWidget {
  const _LoanWalletIcon();

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
  const _MonthHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SakuColors.blue100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.chevron_left_rounded, color: SakuColors.blue900),
          Expanded(
            child: Column(
              children: [
                Text(
                  'April',
                  style: TextStyle(
                    color: SakuColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '2026',
                  style: TextStyle(
                    color: SakuColors.neutral700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: SakuColors.blue900),
        ],
      ),
    );
  }
}
