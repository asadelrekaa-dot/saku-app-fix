import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/models/dashboard_models.dart';
import '../dashboard_shared.dart';
import 'wallet_icon_picker.dart';

class WalletFormDialog extends StatefulWidget {
  const WalletFormDialog({super.key, required this.onSave, this.existing});

  final void Function(WalletItem wallet, bool isPrimary) onSave;
  final WalletItem? existing;

  @override
  State<WalletFormDialog> createState() => WalletFormDialogState();
}

class WalletFormDialogState extends State<WalletFormDialog> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String? _selectedIcon;
  bool _isPrimary = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _nameController.text = widget.existing!.name;
      _balanceController.text = widget.existing!.balance.toString();
      _selectedIcon = widget.existing!.icon;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _openIconPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: SakuColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => WalletIconPicker(
        selectedIcon: _selectedIcon,
        onSelected: (iconName) {
          setState(() => _selectedIcon = iconName);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    final balance = parseCurrency(_balanceController.text);
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dompet belum diisi')),
      );
      return;
    }
    final wallet = widget.existing != null
        ? WalletItem(id: widget.existing!.id, name: name, balance: balance, icon: _selectedIcon)
        : WalletItem(id: -DateTime.now().microsecondsSinceEpoch, name: name, balance: balance, icon: _selectedIcon);
    widget.onSave(wallet, _isPrimary);
  }

  @override
  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.sizeOf(context).height -
        MediaQuery.viewInsetsOf(context).bottom -
        32;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.bottomCenter,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: SakuColors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: availableHeight),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.existing != null ? 'Edit Dompet' : 'Buat Dompet baru',
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: WalletDialogField(
                      label: 'Nama Dompet',
                      child: TextField(
                        controller: _nameController,
                        decoration: _walletInputDecoration('Nama dompet'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: WalletDialogField(
                      label: 'Pilih Icon',
                      child: Material(
                        color: SakuColors.white,
                        borderRadius: BorderRadius.circular(28),
                        child: InkWell(
                          onTap: _openIconPicker,
                          borderRadius: BorderRadius.circular(28),
                          child: Container(
                            height: 51,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              border:
                                  Border.all(color: SakuColors.neutral300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_selectedIcon != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      'assets/icons/dompet/$_selectedIcon',
                                      width: 24,
                                      height: 24,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: SakuColors.mango500,
                                  ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: SakuColors.black,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.existing == null)
                WalletDialogField(
                  label: 'Saldo Awal',
                  child: TextField(
                    controller: _balanceController,
                    keyboardType: TextInputType.number,
                    decoration: _walletInputDecoration('Masukkan saldo awal..'),
                  ),
                ),
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => _isPrimary = !_isPrimary),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isPrimary,
                      onChanged: (value) {
                        setState(() => _isPrimary = value ?? false);
                      },
                      shape: const CircleBorder(),
                      side: const BorderSide(color: SakuColors.neutral300),
                      activeColor: SakuColors.blue300,
                    ),
                    const Expanded(
                      child: Text(
                        'Jadikan Dompet Utama',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: SakuColors.neutral300,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SakuColors.mango500,
                        side: const BorderSide(
                          color: SakuColors.mango500,
                          width: 2.4,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: SakuColors.blue300,
                        foregroundColor: SakuColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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

class WalletDialogField extends StatelessWidget {
  const WalletDialogField({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: SakuColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

InputDecoration _walletInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: SakuColors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: SakuColors.neutral300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: SakuColors.neutral300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: SakuColors.blue300),
    ),
  );
}
