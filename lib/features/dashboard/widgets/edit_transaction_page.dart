import '../../../core/api/laravel_api_service.dart';

import 'dashboard_shared.dart';
import 'add_note_page.dart';

class EditTransactionDashboard extends StatefulWidget {
  const EditTransactionDashboard({
    super.key,
    required this.item,
    required this.onBack,
    required this.onSave,
  });

  final DashboardTransaction? item;
  final VoidCallback onBack;
  final void Function(
      DashboardTransaction oldItem, DashboardTransaction newItem) onSave;

  @override
  State<EditTransactionDashboard> createState() =>
      EditTransactionDashboardState();
}

class EditTransactionDashboardState extends State<EditTransactionDashboard> {
  late final TextEditingController _nameController;
  late final TextEditingController _noteController;
  late final TextEditingController _amountController;
  late String _category;
  int? _selectedWalletId;
  String _selectedWalletName = 'Dompet';
  List<WalletItem> _wallets = [];
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late DateTime _deadlineDate;

  static const _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  DashboardTransaction? get _item => widget.item;
  bool get _isLoan => _item?.title == 'Beri Pinjaman';
  bool get _isDebt => _item?.title == 'Hutang';
  bool get _isDaily => !_isLoan && !_isDebt;
  bool get _isIncome => (_item?.amountValue ?? 0) > 0 && _isDaily;

  String get _dateText {
    return '${_selectedDate.day} ${_months[_selectedDate.month - 1]} ${_selectedDate.year}';
  }

  String get _timeText {
    return '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
  }

  String get _deadlineText {
    return '${_deadlineDate.day} ${_months[_deadlineDate.month - 1]} ${_deadlineDate.year}';
  }

  DateTime? _parseDateFromItem(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      if (parts.length < 3) return null;
      final day = int.tryParse(parts[0]);
      final monthIdx = _months.indexOf(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day == null || monthIdx < 0 || year == null) return null;
      return DateTime(year, monthIdx + 1, day);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    final item = _item;
    final now = DateTime.now();
    _selectedDate = item != null ? (_parseDateFromItem(item.date) ?? now) : now;
    _selectedTime = item != null
        ? TimeOfDay(
            hour: int.tryParse(item.time.split(':').firstOrNull ?? '') ?? now.hour,
            minute: int.tryParse(item.time.split(':').lastOrNull ?? '') ?? now.minute,
          )
        : TimeOfDay.fromDateTime(now);

    _deadlineDate = item != null && item.deadline != null
        ? (DateTime.tryParse(item.deadline!) ?? now.add(const Duration(days: 30)))
        : now.add(const Duration(days: 30));

    final person = item == null
        ? ''
        : item.note
            .replaceFirst('Pinjaman ke ', '')
            .replaceFirst('Hutang ke ', '')
            .trim();
    _category = item?.title ?? 'Makanan';
    _nameController = TextEditingController(text: person);
    _noteController = TextEditingController(text: item?.note ?? '');
    _amountController = TextEditingController(
      text: item == null ? '' : formatPlain(item.amountValue.abs()),
    );
    _fetchWallets();
  }

  Future<void> _fetchWallets() async {
    final wallets = await LaravelApiService.instance.getWallets();
    if (!mounted) return;
    setState(() {
      _wallets = wallets;
      if (wallets.isNotEmpty) {
        _selectedWalletId = wallets.first.id;
        _selectedWalletName = wallets.first.name;
      }
    });
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
    _amountController.dispose();
    super.dispose();
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

  Future<void> _openCategoryPicker() async {
    final category = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => CategorySelectionPage(
          selectedCategory: _category,
          kind: _isIncome ? CategoryKind.income : CategoryKind.expense,
        ),
      ),
    );
    if (category == null) return;
    setState(() => _category = category);
  }

  void _save() {
    final item = _item;
    if (item == null) return;
    final amount = parseCurrency(_amountController.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal belum diisi')),
      );
      return;
    }

    final rawDate = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day,
      _selectedTime.hour, _selectedTime.minute,
    ).toIso8601String();

    final deadline = _isDaily
        ? null
        : DateTime(
            _deadlineDate.year, _deadlineDate.month, _deadlineDate.day,
          ).toIso8601String();

    final name = _nameController.text.trim();
    final note = _noteController.text.trim();
    final title = _isDaily ? _category : item.title;
    final isMoneyOut = item.amountValue < 0;
    widget.onSave(
      item,
      item.copyWith(
        title: title,
        note: note.isNotEmpty
            ? note
            : _isDaily
                ? 'Catatan $title'
                : '${_isLoan ? 'Pinjaman ke' : 'Hutang ke'} ${name.isEmpty ? 'Nama' : name}',
        amountValue: isMoneyOut ? -amount : amount,
        date: _dateText,
        time: _timeText,
        rawDate: rawDate,
        deadline: deadline,
        icon: categoryIcon(title),
        color: isMoneyOut ? SakuColors.danger : SakuColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    if (item == null) {
      return Column(
        children: [
          ChildPageTopBar(title: 'Edit Catatan', onBack: widget.onBack),
          const Expanded(
            child: Center(child: Text('Catatan tidak ditemukan')),
          ),
        ],
      );
    }

    return Column(
      children: [
        ChildPageTopBar(title: 'Edit Catatan', onBack: widget.onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 22, 32, 22),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _EditTappablePillField(
                      text: _dateText,
                      icon: Icons.calendar_month_rounded,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _EditTappablePillField(
                      text: _timeText,
                      icon: Icons.access_time_filled_rounded,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (_isDaily)
                SelectablePillField(
                  label: 'Kategori',
                  text: _category,
                  icon: categoryIcon(_category),
                  onTap: _openCategoryPicker,
                )
              else ...[
                EditablePillField(
                  label: 'Nama',
                  controller: _nameController,
                ),
                const SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jatuh Tempo',
                      style: TextStyle(
                        color: SakuColors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _EditTappablePillField(
                      text: _deadlineText,
                      icon: Icons.calendar_month_rounded,
                      onTap: _pickDeadlineDate,
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
              const SizedBox(height: 14),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nominal',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: SakuColors.white,
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
              const SizedBox(height: 20),
              SizedBox(
                width: 164,
                child: WalletPicker(
                  walletName: _selectedWalletName,
                  onTap: _openWalletPicker,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: SakuColors.white,
          padding: const EdgeInsets.fromLTRB(32, 14, 32, 18),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SakuColors.mango500,
                    side:
                        const BorderSide(color: SakuColors.mango500, width: 2),
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
              const SizedBox(width: 14),
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: SakuColors.blue300,
                    foregroundColor: SakuColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontWeight: FontWeight.w900),
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

class _EditTappablePillField extends StatelessWidget {
  const _EditTappablePillField({
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
