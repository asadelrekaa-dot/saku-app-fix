import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_shared.dart'; // Jika satu folder, ini sudah benar
import 'category_picker_component.dart'; // Jika satu folder, ini sudah benar

// SESUAIKAN PATH INI: naik 2 tingkat lalu masuk ke folder bloc/add_note
import '../bloc/add_note/add_note_bloc.dart';// Import file BLoC kamu

class AddNoteDashboard extends StatelessWidget {
  AddNoteDashboard({
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

  // Controller text tetap dideklarasikan di sini karena berinteraksi langsung dengan TextField UI
  final _nameController = TextEditingController(text: 'Nama');
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Membuka bloc dan mengirim event started untuk inisialisasi mode awal
    return BlocProvider(
      create: (context) => AddNoteBloc()..add(AddNoteEvent.started(mode)),
      child: BlocListener<AddNoteBloc, AddNoteState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AddNoteStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          } else if (state.status == AddNoteStatus.success) {
            // Membuka kembali data kalkulasi final dari bloc untuk dikirim ke fungsi onSave di page utama
            final numericAmount = int.tryParse(state.amount) ?? 0;
            final title = state.isDailyNote
                ? state.selectedCategory
                : state.isLoan
                    ? 'Beri Pinjaman'
                    : 'Hutang';
            final isMoneyOut = state.isExpense || state.isLoan;
            final name = _nameController.text.trim();
            final note = _noteController.text.trim();

            onSave(
              DashboardTransaction(
                title: title,
                note: note.isNotEmpty
                    ? note
                    : state.isDailyNote
                        ? 'Catatan $title'
                        : '${state.isLoan ? 'Pinjaman ke' : 'Hutang ke'} ${name.isEmpty ? 'Nama' : name}',
                amountValue: isMoneyOut ? -numericAmount : numericAmount,
                date: '21 April 2026',
                time: 'Baru saja',
                icon: categoryIcon(title),
                color: isMoneyOut ? SakuColors.danger : SakuColors.success,
              ),
            );
          }
        },
        child: BlocBuilder<AddNoteBloc, AddNoteState>(
          builder: (context, state) {
            return Column(
              children: [
                ChildPageTopBar(title: 'Tambah Catatan', onBack: onBack),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(32, 18, 32, 14),
                    children: [
                      _AddNoteTypeSelector(
                        mode: state.mode,
                        onSwitchMode: (newMode) {
                          context.read<AddNoteBloc>().add(AddNoteEvent.modeChanged(newMode));
                          onSwitchMode(newMode);
                        },
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        children: [
                          Expanded(
                            child: _PillField(
                              text: '21 April 2026',
                              icon: Icons.calendar_month_rounded,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: _PillField(
                              text: '8:21 AM',
                              icon: Icons.access_time_filled_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (state.isDailyNote) ...[
                        SelectablePillField(
                          label: 'Kategori',
                          text: state.selectedCategory,
                          icon: categoryIcon(state.selectedCategory),
                          onTap: () async {
                            // Memanggil Bottom Sheet dari file terpisah yang sudah dibuat sebelumnya
                            final category = await CategoryPickerComponent.showAsBottomSheet(
                              context: context,
                              selectedCategory: state.selectedCategory,
                              kind: state.isIncome ? CategoryKind.income : CategoryKind.expense,
                            );
                            if (category != null && context.mounted) {
                              context.read<AddNoteBloc>().add(AddNoteEvent.categoryChanged(category));
                            }
                          },
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
                        const SizedBox(
                          width: 164,
                          child: WalletPicker(),
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
                            const Expanded(
                              child: _LabeledPillField(
                                label: 'Jatuh Tempo',
                                text: '12 Juni 2026',
                                icon: Icons.calendar_month_rounded,
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
                      if (state.isLoan) ...[
                        const SizedBox(height: 14),
                        const Text(
                          'Dompet',
                          style: TextStyle(
                            color: SakuColors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const SizedBox(
                          width: 164,
                          child: WalletPicker(),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  color: SakuColors.blue50,
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 12),
                  child: Column(
                    children: [
                      _AmountDisplay(amount: state.amount),
                      const SizedBox(height: 6),
                      _CalculatorPad(
                        onTap: (key) {
                          if (key == 'Simpan') {
                            context.read<AddNoteBloc>().add(
                                  AddNoteEvent.saveSubmitted(
                                    name: _nameController.text,
                                    note: _noteController.text,
                                  ),
                                );
                          } else {
                            context.read<AddNoteBloc>().add(AddNoteEvent.keypadTapped(key));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// =========================================================================
// WIDGET-WIDGET PENDUKUNG DI BAWAH INI TETAP SAMA KARENA UTK LAYOUTING SAJA
// =========================================================================

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

class WalletPicker extends StatelessWidget {
  const WalletPicker({super.key});

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
      child: const Row(
        children: [
          Icon(Icons.credit_card_rounded, color: SakuColors.mango500),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'BSI',
              style: TextStyle(
                color: SakuColors.neutral700,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, color: SakuColors.black),
        ],
      ),
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
          color: SakuColors.neutral700,
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
              ? const Icon(Icons.backspace_outlined, color: SakuColors.neutral600)
              : Text(
                  label,
                  style: TextStyle(
                    color: label == 'Simpan' ? SakuColors.white : SakuColors.black,
                    fontSize: label == 'Simpan' ? 18 : 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }
}