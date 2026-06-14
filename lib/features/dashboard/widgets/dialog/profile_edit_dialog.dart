import 'package:flutter/material.dart';

import '../dashboard_shared.dart';

enum ProfileEditField { name, email, password }

class ProfileEditDialog extends StatefulWidget {
  const ProfileEditDialog({
    super.key,
    required this.field,
    required this.currentName,
    required this.currentEmail,
    required this.onSaveName,
    required this.onSaveEmail,
    required this.onSavePassword,
  });

  final ProfileEditField field;
  final String currentName;
  final String currentEmail;
  final ValueChanged<String> onSaveName;
  final ValueChanged<String> onSaveEmail;
  final void Function(String oldPassword, String newPassword) onSavePassword;

  @override
  State<ProfileEditDialog> createState() => ProfileEditDialogState();
}

class ProfileEditDialogState extends State<ProfileEditDialog> {
  late final TextEditingController _primaryController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool get _isName => widget.field == ProfileEditField.name;
  bool get _isEmail => widget.field == ProfileEditField.email;
  bool get _isPassword => widget.field == ProfileEditField.password;

  String get _title {
    return switch (widget.field) {
      ProfileEditField.name => 'Edit Nama',
      ProfileEditField.email => 'Edit Email',
      ProfileEditField.password => 'Ganti Password',
    };
  }

  @override
  void initState() {
    super.initState();
    _primaryController = TextEditingController(
      text: _isName
          ? widget.currentName
          : _isEmail
              ? widget.currentEmail
              : '',
    );
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _save() {
    if (_isPassword) {
      final oldPassword = _primaryController.text.trim();
      final newPassword = _passwordController.text.trim();
      if (newPassword.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password baru minimal 6 karakter'),
          ),
        );
        return;
      }
      widget.onSavePassword(oldPassword, newPassword);
      return;
    }

    final value = _primaryController.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data belum diisi')),
      );
      return;
    }

    if (_isEmail && !value.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email belum benar')),
      );
      return;
    }

    if (_isName) {
      widget.onSaveName(value);
    } else {
      widget.onSaveEmail(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 22),
            if (!_isPassword)
              ProfileEditFieldInput(
                label: _isEmail ? 'Email' : 'Nama',
                controller: _primaryController,
                keyboardType:
                    _isEmail ? TextInputType.emailAddress : TextInputType.text,
                icon: _isEmail ? Icons.mail_rounded : Icons.person_rounded,
              )
            else ...[
              ProfileEditFieldInput(
                label: 'Password lama',
                controller: _primaryController,
                obscureText: true,
                icon: Icons.edit_rounded,
                hintText: 'Masukkan password lama',
              ),
              const SizedBox(height: 14),
              ProfileEditFieldInput(
                label: 'Password baru',
                controller: _passwordController,
                obscureText: true,
                icon: Icons.edit_rounded,
                hintText: 'Masukkan password baru',
              ),
            ],
            const SizedBox(height: 34),
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
          ],
        ),
      ),
    );
  }
}

class ProfileEditFieldInput extends StatelessWidget {
  const ProfileEditFieldInput({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
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
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: Icon(icon, color: SakuColors.black),
            filled: true,
            fillColor: SakuColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
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
      ],
    );
  }
}
