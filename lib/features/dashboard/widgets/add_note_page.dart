import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/api/laravel_api_service.dart';
import '../../../core/repository/local_repository.dart';
import '../../../core/utils/expression_calculator.dart';

import 'dashboard_shared.dart';
import 'dialog/category_picker_sheet.dart';
import 'dialog/wallet_picker_sheet.dart';

class AddNoteDashboard extends StatefulWidget {
  const AddNoteDashboard({
    super.key,
    required this.mode,
    required this.onBack,
    required this.onSwitchMode,
    required this.onSave,
  });

  final AddNoteMode mode;
  final VoidCallback onBack;
  final ValueChanged<AddNoteMode> onSwitchMode;
  final ValueChanged<DashboardTransaction> onSave;

  @override
  State<AddNoteDashboard> createState() => AddNoteDashboardState();
}

class AddNoteDashboardState extends State<AddNoteDashboard> {
  final _nameController = TextEditingController(text: 'Nama');
  final _noteController = TextEditingController();
  String _amount = '0';
  String _expression = '';
  bool _isNewEntry = true;
  bool _showCalculator = false;
  String _expenseCategory = 'Makanan';
  String _incomeCategory = 'Gaji';
  int? _selectedWalletId;
  String _selectedWalletName = 'Dompet';
  String? _selectedWalletIcon;
  List<WalletItem> _wallets = [];
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late DateTime _deadlineDate;

  bool get _isLoan => widget.mode == AddNoteMode.loan;
  bool get _isIncome => widget.mode == AddNoteMode.income;
  bool get _isExpense => widget.mode == AddNoteMode.expense;
  bool get _isDailyNote => _isExpense || _isIncome;
  String get _selectedCategory =>
      _isIncome ? _incomeCategory : _expenseCategory;

  String get _todayDate {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';
  }

  String get _currentTime {
    return '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
  }

  String get _deadlineDateStr {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${_deadlineDate.day} ${months[_deadlineDate.month - 1]} ${_deadlineDate.year}';
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = now;
    _selectedTime = TimeOfDay.fromDateTime(now);
    _deadlineDate = now.add(const Duration(days: 30));
    _fetchWallets();
  }

  Future<void> _fetchWallets() async {
    final repo = const LocalRepository();
    try {
      final wallets = await LaravelApiService.instance.getWallets();
      if (wallets.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _wallets = wallets;
          _selectedWalletId = wallets.first.id;
          _selectedWalletName = wallets.first.name;
          _selectedWalletIcon = wallets.first.icon;
        });
        return;
      }
    } catch (_) {}
    final local = await repo.loadWallets();
    if (local.isNotEmpty && mounted) {
      setState(() {
        _wallets = local;
        _selectedWalletId = local.first.id;
        _selectedWalletName = local.first.name;
        _selectedWalletIcon = local.first.icon;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: 'Pilih Waktu',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (picked != null && mounted) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _pickDeadlineDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadlineDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Pilih Jatuh Tempo',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (picked != null && mounted) {
      setState(() => _deadlineDate = picked);
    }
  }

  Future<void> _openWalletPicker() async {
    await showModalBottomSheet<int>(
      context: context,
      builder: (context) => WalletPickerSheet(
        wallets: _wallets,
        selectedId: _selectedWalletId,
        onSelected: (id, name) {
          Navigator.of(context).pop();
          setState(() {
            _selectedWalletId = id;
            _selectedWalletName = name;
            _selectedWalletIcon = _wallets
                .firstWhere((w) => w.id == id, orElse: () => _wallets.first)
                .icon;
          });
          LaravelApiService.instance.cacheWalletId(id);
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _handleKeypadTap(String key) {
    if (key == 'Simpan') {
      _saveNote();
      return;
    }
    setState(() {
      if (key == 'C') {
        _amount = '0';
        _expression = '';
        _isNewEntry = true;
      } else if (key == 'back') {
        if (_amount.length <= 1) {
          _amount = '0';
        } else {
          _amount = _amount.substring(0, _amount.length - 1);
        }
      } else if (key == '+' || key == '-' || key == 'x') {
        if (_amount != '0') {
          _expression = '$_expression$_amount $key ';
          _amount = '0';
          _isNewEntry = true;
        }
      } else if (key == '=') {
        if (_expression.isNotEmpty && _amount != '0') {
          final expr = '$_expression$_amount';
          _amount = ExpressionCalculator.evaluate(expr);
          _expression = '';
          _isNewEntry = true;
        }
      } else if (RegExp(r'^\d+$').hasMatch(key)) {
        if (_isNewEntry) {
          _amount = key;
          _isNewEntry = false;
        } else {
          _amount = _amount == '0' ? key : '$_amount$key';
        }
      }
    });
  }

  void _saveNote() {
    final numericAmount = int.tryParse(_amount) ?? 0;
    if (numericAmount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal belum diisi')),
      );
      return;
    }

    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final dateStr = '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';
    final timeStr = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    final rawDate = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day,
      _selectedTime.hour, _selectedTime.minute,
    ).toIso8601String();

    final deadline = _isDailyNote
        ? null
        : DateTime(
            _deadlineDate.year, _deadlineDate.month, _deadlineDate.day,
          ).toIso8601String();

    final name = _nameController.text.trim();
    final note = _noteController.text.trim();
    final title = _isDailyNote
        ? _selectedCategory
        : _isLoan
            ? 'Beri Pinjaman'
            : 'Hutang';
    final isMoneyOut = _isExpense || _isLoan;
    widget.onSave(
      DashboardTransaction(
        title: title,
        note: note.isNotEmpty
            ? note
            : _isDailyNote
                ? 'Catatan $title'
                : '${_isLoan ? 'Pinjaman ke' : 'Hutang ke'} ${name.isEmpty ? 'Nama' : name}',
        amountValue: isMoneyOut ? -numericAmount : numericAmount,
        date: dateStr,
        time: timeStr,
        rawDate: rawDate,
        deadline: deadline,
        icon: categoryIcon(title),
        color: isMoneyOut ? SakuColors.danger : SakuColors.success,
      ),
    );
  }

  Future<void> _openCategoryPicker() async {
    final category = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => CategorySelectionPage(
          selectedCategory: _selectedCategory,
          kind: _isIncome ? CategoryKind.income : CategoryKind.expense,
        ),
      ),
    );
    if (category == null) return;
    setState(() {
      if (_isIncome) {
        _incomeCategory = category;
      } else {
        _expenseCategory = category;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChildPageTopBar(title: 'Tambah Catatan', onBack: widget.onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 18, 32, 14),
            children: [
              _AddNoteTypeSelector(
                mode: widget.mode,
                onSwitchMode: widget.onSwitchMode,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _TappablePillField(
                      text: _todayDate,
                      icon: Icons.calendar_month_rounded,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _TappablePillField(
                      text: _currentTime,
                      icon: Icons.access_time_filled_rounded,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (_isDailyNote) ...[
                SelectablePillField(
                  label: 'Kategori',
                  text: _selectedCategory,
                  icon: categoryIcon(_selectedCategory),
                  onTap: _openCategoryPicker,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Dompet',
                  style: TextStyle(
                    color: SakuColors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 164,
                  child: WalletPicker(
                    walletName: _selectedWalletName,
                    walletIcon: _selectedWalletIcon,
                    onTap: _openWalletPicker,
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: EditablePillField(
                        label: 'Nama',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _LabeledTappablePillField(
                        label: 'Jatuh Tempo',
                        text: _deadlineDateStr,
                        icon: Icons.calendar_month_rounded,
                        onTap: _pickDeadlineDate,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              EditablePillField(
                label: 'Catatan',
                controller: _noteController,
                hintText: 'Tulis catatan atau keterangan disini',
              ),
              if (_isLoan) ...[
                const SizedBox(height: 14),
                const Text(
                  'Dompet',
                  style: TextStyle(
                    color: SakuColors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 164,
                  child: WalletPicker(
                    walletName: _selectedWalletName,
                    walletIcon: _selectedWalletIcon,
                    onTap: _openWalletPicker,
                  ),
                ),
              ],
            ],
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _showCalculator = !_showCalculator),
          child: Container(
            color: _showCalculator ? SakuColors.blue50 : SakuColors.white,
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 12),
            child: Column(
              children: [
                if (_expression.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        _expression.trim(),
                        style: const TextStyle(
                          color: SakuColors.neutral600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: _AmountDisplay(amount: _amount),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _showCalculator ? Icons.keyboard_arrow_down : Icons.calculate,
                      color: SakuColors.neutral600,
                    ),
                  ],
                ),
                if (_showCalculator) ...[
                  const SizedBox(height: 6),
                  _CalculatorPad(onTap: _handleKeypadTap),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({
    super.key,
    required this.selectedCategory,
    required this.kind,
  });

  final String selectedCategory;
  final CategoryKind kind;

  @override
  Widget build(BuildContext context) {
    final categories = categoriesForKind(kind);
    final title = kind == CategoryKind.income
        ? 'Kategori Pemasukan'
        : 'Kategori Pengeluaran';

    return Scaffold(
      backgroundColor: SakuColors.neutral50,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 430,
            child: Column(
              children: [
                ChildPageTopBar(
                  title: title,
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _CategoryPageTile(
                        title: category,
                        selected: category == selectedCategory,
                        onTap: () => Navigator.of(context).pop(category),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPageTile extends StatelessWidget {
  const _CategoryPageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final asset = categoryAsset(title);
    return Material(
      color: SakuColors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: selected ? 4 : 2,
      shadowColor: SakuColors.black.withValues(alpha: 0.26),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? SakuColors.blue300 : SakuColors.neutral300,
              width: selected ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (asset != null)
                ClipRect(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset(
                      asset,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                )
              else
                Icon(categoryIcon(title), color: SakuColors.mango500, size: 28),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: SakuColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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


class _AddNoteTypeSelector extends StatelessWidget {
  const _AddNoteTypeSelector({
    required this.mode,
    required this.onSwitchMode,
  });

  final AddNoteMode mode;
  final ValueChanged<AddNoteMode> onSwitchMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: SakuColors.neutral100,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            flex: mode == AddNoteMode.expense ? 5 : 2,
            child: _ModeChip(
              selected: mode == AddNoteMode.expense,
              label: 'Pengeluaran',
              icon: Icons.paid_outlined,
              onTap: () => onSwitchMode(AddNoteMode.expense),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: mode == AddNoteMode.income ? 5 : 2,
            child: _ModeChip(
              selected: mode == AddNoteMode.income,
              label: 'Pemasukan',
              icon: Icons.savings_outlined,
              onTap: () => onSwitchMode(AddNoteMode.income),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: mode == AddNoteMode.debt ? 5 : 2,
            child: _ModeChip(
              selected: mode == AddNoteMode.debt,
              label: 'Hutang',
              icon: Icons.payments_outlined,
              onTap: () => onSwitchMode(AddNoteMode.debt),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: mode == AddNoteMode.loan ? 6 : 2,
            child: _ModeChip(
              selected: mode == AddNoteMode.loan,
              label: 'Beri Pinjaman',
              icon: Icons.request_quote_outlined,
              onTap: () => onSwitchMode(AddNoteMode.loan),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? SakuColors.blue100 : Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: SakuColors.black, size: 24),
              if (selected) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: const TextStyle(
                        color: SakuColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({required this.text, this.icon});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: SakuColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SakuColors.neutral300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: SakuColors.neutral700,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (icon != null) Icon(icon, color: SakuColors.neutral300),
        ],
      ),
    );
  }
}

class _LabeledPillField extends StatelessWidget {
  const _LabeledPillField({
    required this.label,
    required this.text,
    this.icon,
  });

  final String label;
  final String text;
  final IconData? icon;

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
        _PillField(text: text, icon: icon),
      ],
    );
  }
}

class _TappablePillField extends StatelessWidget {
  const _TappablePillField({
    required this.text,
    this.icon,
    required this.onTap,
  });

  final String text;
  final IconData? icon;
  final VoidCallback onTap;

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
              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SakuColors.neutral700,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, color: SakuColors.neutral300),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledTappablePillField extends StatelessWidget {
  const _LabeledTappablePillField({
    required this.label,
    required this.text,
    this.icon,
    required this.onTap,
  });

  final String label;
  final String text;
  final IconData? icon;
  final VoidCallback onTap;

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
        _TappablePillField(text: text, icon: icon, onTap: onTap),
      ],
    );
  }
}

class SelectablePillField extends StatelessWidget {
  const SelectablePillField({
    super.key,
    required this.label,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String text;
  final IconData icon;
  final VoidCallback onTap;

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: SakuColors.neutral300),
              ),
              child: Row(
                children: [
                  Icon(icon, color: SakuColors.mango500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: SakuColors.neutral700,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EditablePillField extends StatelessWidget {
  const EditablePillField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;

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
        SizedBox(
          height: 48,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: SakuColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: SakuColors.neutral300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: SakuColors.neutral300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: SakuColors.blue300),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: SakuColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: SakuColors.neutral300),
      ),
      alignment: Alignment.centerRight,
      child: Text(
        formatPlain(int.tryParse(amount) ?? 0),
        style: const TextStyle(
          color: SakuColors.neutral300,
          fontSize: 31,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CalculatorPad extends StatelessWidget {
  const _CalculatorPad({required this.onTap});

  final ValueChanged<String> onTap;

  static const _rows = [
    ['x', '-', '+', 'back'],
    ['1', '2', '3', 'C'],
    ['4', '5', '6', '='],
    ['7', '8', '9', 'Simpan'],
    ['', '0', '000', 'Simpan'],
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Column(
        children: List.generate(_rows.length, (rowIndex) {
          return Expanded(
            child: Row(
              children: List.generate(_rows[rowIndex].length, (index) {
                final label = _rows[rowIndex][index];
                if (label.isEmpty) {
                  return const Expanded(child: SizedBox.shrink());
                }
                if (label == 'Simpan' && rowIndex == 4) {
                  return const Expanded(child: SizedBox.shrink());
                }
                final rowSpan = label == 'Simpan';
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: SizedBox(
                      height: rowSpan ? double.infinity : null,
                      child: _KeypadButton(
                        label: label,
                        tall: rowSpan,
                        onTap: () => onTap(label),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.label,
    required this.onTap,
    this.tall = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    final isAction = label == '=' || label == 'Simpan';
    final isMuted = label == 'back' || label == 'C' || label == 'Simpan';

    return Material(
      color: isAction
          ? (label == '=' ? SakuColors.blue100 : SakuColors.neutral300)
          : (isMuted ? SakuColors.neutral100 : SakuColors.white),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Center(
          child: label == 'back'
              ? const Icon(Icons.backspace_outlined,
                  color: SakuColors.neutral600)
              : Text(
                  label,
                  style: TextStyle(
                    color:
                        label == 'Simpan' ? SakuColors.white : SakuColors.black,
                    fontSize: label == 'Simpan' ? 18 : 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }
}
