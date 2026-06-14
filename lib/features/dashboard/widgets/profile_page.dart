import 'dart:developer';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/api/laravel_api_service.dart';
import '../../../core/repository/local_repository.dart';
import '../../auth/google_auth_service.dart';
import '../../auth/login_page.dart';
import 'dashboard_shared.dart';
import 'dialog/profile_edit_dialog.dart';
import 'dialog/wallet_detail_dialog.dart';
import 'dialog/wallet_form_dialog.dart';

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.onOpenNotifications,
    required this.onAddHomeWidget,
    this.onProfileUpdated,
  });

  final String initialName;
  final String initialEmail;
  final VoidCallback onOpenNotifications;
  final VoidCallback onAddHomeWidget;
  final void Function(String name, String email, String? photoUrl)? onProfileUpdated;

  @override
  State<ProfileDashboard> createState() => ProfileDashboardState();
}

class ProfileDashboardState extends State<ProfileDashboard> {
  late String _profileName;
  late String _profileEmail;
  String? _photoUrl;
  bool _passwordChanged = false;
  bool _photoUpdated = false;
  List<WalletItem> _wallets = [];
  bool _isLoading = true;
  final _repo = const LocalRepository();

  @override
  void initState() {
    super.initState();
    _profileName = widget.initialName;
    _profileEmail = widget.initialEmail;
    _loadData();
  }

  Future<void> _loadData() async {
    // Load wallets from local DB instantly
    final localWallets = await _repo.loadWallets();
    if (localWallets.isNotEmpty && mounted) {
      setState(() => _wallets = localWallets);
    }

    // Load local cached photo
    final localPhotoPath = '${Directory.systemTemp.path}/saku_photos/profile_photo.jpg';
    if (await File(localPhotoPath).exists() && mounted) {
      setState(() => _photoUrl = localPhotoPath);
    }

    // Load saved local user data
    final saved = await LaravelApiService.instance.getSavedUser();
    if (saved != null && mounted) {
      setState(() {
        _profileName = saved.name;
        _profileEmail = saved.email;
      });
    }

    try {
      final profile = await LaravelApiService.instance.getProfile();
      if (mounted) {
        setState(() {
          _profileName = profile.name;
          _profileEmail = profile.email;
          _photoUrl = profile.photoUrl ?? _photoUrl;
        });
      }
    } catch (_) {
      // keep local values
    }
    try {
      final wallets = await _repo.loadWallets();
      if (mounted && wallets.isNotEmpty) {
        setState(() => _wallets = wallets);
      }
    } catch (_) {
      // keep local wallets
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _openAddWalletDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => WalletFormDialog(
        onSave: (wallet, isPrimary) {
          Navigator.of(ctx).pop();
          setState(() => _wallets.add(wallet));
          _syncWalletToApi(wallet, isPrimary: isPrimary);
        },
      ),
    );
  }

  void _editWallet(WalletItem item) {
    showDialog<void>(
      context: context,
      builder: (ctx) => WalletFormDialog(
        existing: item,
        onSave: (updated, isPrimary) async {
          Navigator.of(ctx).pop();
          try {
            final result = await LaravelApiService.instance.updateWallet(
              id: updated.id!,
              name: updated.name,
              isPrimary: isPrimary,
              icon: updated.icon,
            );
            if (!mounted) return;
            setState(() {
              final index = _wallets.indexWhere((w) => w.id == item.id);
              if (index != -1) {
                _wallets[index] = WalletItem(
                  id: result.id,
                  name: result.name,
                  balance: item.balance,
                  icon: result.icon ?? updated.icon,
                );
              }
            });
            await _repo.replaceAllWallets(_wallets);
          } catch (_) {
            if (!mounted) return;
            setState(() {
              final index = _wallets.indexWhere((w) => w.id == item.id);
              if (index != -1) {
                _wallets[index] = WalletItem(
                  id: item.id,
                  name: updated.name,
                  balance: item.balance,
                  icon: updated.icon,
                );
              }
            });
            await _repo.replaceAllWallets(_wallets);
          }
        },
      ),
    );
  }

  Future<void> _syncWalletToApi(WalletItem wallet, {bool isPrimary = false}) async {
    try {
      final created = await LaravelApiService.instance.createWallet(
        name: wallet.name,
        balance: wallet.balance,
        isPrimary: isPrimary,
        icon: wallet.icon,
      );
      if (!mounted) return;
      setState(() {
        final index = _wallets.indexWhere((w) => identical(w, wallet));
        if (index != -1) {
          _wallets[index] = created;
        }
      });
    } catch (_) {
      // API failed, keep local version
    }
    await _repo.replaceAllWallets(_wallets);
  }

  void _openProfileEditDialog(ProfileEditField field) {
    showDialog<void>(
      context: context,
      builder: (context) => ProfileEditDialog(
        field: field,
        currentName: _profileName,
        currentEmail: _profileEmail,
        onSaveName: (value) {
          setState(() => _profileName = value);
          Navigator.of(context).pop();
          _updateProfileOnApi(value, _profileEmail);
        },
        onSaveEmail: (value) {
          setState(() => _profileEmail = value);
          Navigator.of(context).pop();
          _updateProfileOnApi(_profileName, value);
        },
        onSavePassword: (oldPassword, newPassword) {
          Navigator.of(context).pop();
          _updatePasswordOnApi(oldPassword, newPassword);
        },
      ),
    );
  }

  Future<void> _updateProfileOnApi(String name, String email) async {
    // Save locally first
    await LaravelApiService.instance.saveUserLocally(
      name: name,
      email: email,
    );
    try {
      await LaravelApiService.instance.updateProfile(name: name, email: email);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil disimpan secara lokal')),
      );
    }
    widget.onProfileUpdated?.call(name, email, _photoUrl);
  }

  Future<void> _updatePasswordOnApi(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await LaravelApiService.instance.updatePassword(
        currentPassword: oldPassword,
        newPassword: newPassword,
      );
      if (!mounted) return;
      setState(() => _passwordChanged = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diperbarui')),
      );
    } catch (e) {
      if (!mounted) return;
      final msg = e is LaravelApiException
          ? e.message
          : 'Gagal memperbarui password';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _showProfilePhotoInfo() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (picked == null || !mounted) return;

      // Save locally first
      final localDir = await _getLocalPhotoDir();
      final localPath = '${localDir.path}/profile_photo.jpg';
      final localFile = File(localPath);
      await localFile.writeAsBytes(await File(picked.path).readAsBytes());

      if (!mounted) return;
      setState(() {
        _photoUpdated = true;
        _photoUrl = localPath;
      });

      // Try API upload
      try {
        final url = await LaravelApiService.instance.uploadPhoto(File(picked.path));
        if (!mounted) return;
        if (url.isNotEmpty) {
          setState(() => _photoUrl = url);
        }
        widget.onProfileUpdated?.call(_profileName, _profileEmail, _photoUrl);
      } catch (e) {
        log('[Profile] API upload failed, using local photo', error: e);
        widget.onProfileUpdated?.call(_profileName, _profileEmail, _photoUrl);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
    } catch (e) {
      if (!mounted) return;
      log('[Profile] Photo pick/upload error', error: e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunggah foto profil')),
      );
    }
  }

  Future<Directory> _getLocalPhotoDir() async {
    final dir = Directory('${Directory.systemTemp.path}/saku_photos');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  void _showWalletDetail(WalletItem item) {
    showDialog<void>(
      context: context,
      builder: (context) => WalletDetailDialog(
        item: item,
        onDelete: item.id != null ? () => _deleteWallet(item) : null,
        onEdit: item.id != null ? () => _editWallet(item) : null,
      ),
    );
  }

  Future<void> _deleteWallet(WalletItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Dompet'),
        content: Text('Yakin ingin menghapus dompet "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || item.id == null) return;
    try {
      await LaravelApiService.instance.deleteWallet(id: item.id!);
      if (!mounted) return;
      setState(() => _wallets.removeWhere((w) => w.id == item.id));
      await _repo.replaceAllWallets(_wallets);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus dompet')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        _ProfileHeader(
          name: _profileName,
          photoUpdated: _photoUpdated,
          photoUrl: _photoUrl,
          onEditPhoto: _showProfilePhotoInfo,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 12),
          decoration: const BoxDecoration(
            color: SakuColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileSectionTitle('List Dompet'),
              const SizedBox(height: 12),
              ..._wallets.map(
                (wallet) => _WalletCard(
                  wallet,
                  onTap: () => _showWalletDetail(wallet),
                ),
              ),
              if (_wallets.isNotEmpty) const SizedBox(height: 12),
              _AddWalletCard(onTap: _openAddWalletDialog),
              const SizedBox(height: 24),
              const _ProfileSectionTitle('Informasi Akun'),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.person_rounded,
                title: 'Nama',
                subtitle: _profileName,
                onTap: () => _openProfileEditDialog(ProfileEditField.name),
              ),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.mail_rounded,
                title: 'Email',
                subtitle: _profileEmail,
                onTap: () => _openProfileEditDialog(ProfileEditField.email),
              ),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.lock_rounded,
                title: 'Password',
                subtitle: _passwordChanged ? 'Sudah diperbarui' : '********',
                onTap: () => _openProfileEditDialog(ProfileEditField.password),
              ),
              const SizedBox(height: 24),
              const _ProfileSectionTitle('Pengaturan'),
              const SizedBox(height: 12),
              _NotificationTile(onTap: widget.onOpenNotifications),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.widgets_rounded,
                title: 'Widget Homescreen',
                subtitle: 'Ringkasan saldo di layar utama',
                iconColor: SakuColors.blue700,
                onTap: widget.onAddHomeWidget,
              ),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.logout_rounded,
                title: 'Keluar',
                subtitle: 'Kembali ke halaman masuk',
                iconColor: SakuColors.mango500,
                trailing: Icons.chevron_right_rounded,
                onTap: () async {
                  await LaravelApiService.instance.logout();
                  await GoogleAuthService.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.of(context)
                      .pushReplacementNamed(LoginPage.routeName);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}






class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.photoUpdated,
    required this.onEditPhoto,
    this.photoUrl,
  });

  final String name;
  final bool photoUpdated;
  final VoidCallback onEditPhoto;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        color: SakuColors.blue100,
        image: DecorationImage(
          image: AssetImage('assets/background beranda biru.png'),
          fit: BoxFit.cover,
          opacity: 0.32,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 34,
            child: Container(
              width: 94,
              height: 94,
              decoration: BoxDecoration(
                color: SakuColors.blue50,
                shape: BoxShape.circle,
                border: Border.all(color: SakuColors.white, width: 4),
                image: photoUrl != null
                    ? DecorationImage(
                        image: photoUrl!.startsWith('http')
                            ? NetworkImage(photoUrl!) as ImageProvider
                            : FileImage(File(photoUrl!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: photoUrl == null
                  ? Icon(
                      photoUpdated
                          ? Icons.check_rounded
                          : Icons.person_rounded,
                      color: SakuColors.blue700,
                      size: 62,
                    )
                  : null,
            ),
          ),
          Positioned(
            top: 104,
            right: 165,
            child: Material(
              color: SakuColors.white,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onEditPhoto,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.camera_alt_rounded),
                ),
              ),
            ),
          ),
          Positioned(
            top: 140,
            child: Text(
              name,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: SakuColors.black,
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard(this.item, {required this.onTap});

  final WalletItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: SakuColors.blue50,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: SakuColors.blue100),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: SakuColors.blue300,
                  child: item.icon != null
                      ? Padding(
                          padding: const EdgeInsets.all(6),
                          child: SvgPicture.asset(
                            'assets/icons/dompet/${item.icon}',
                            width: 22,
                            height: 22,
                          ),
                        )
                      : const Icon(Icons.credit_card_rounded,
                          color: SakuColors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: SakuColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Rp ${formatPlain(item.balance)}',
                        style: const TextStyle(
                          color: SakuColors.neutral600,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class _AddWalletCard extends StatelessWidget {
  const _AddWalletCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.neutral100,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: SakuColors.neutral300),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: SakuColors.neutral300,
                child:
                    Icon(Icons.add_rounded, color: SakuColors.white, size: 34),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Tambah dompet baru',
                  style: TextStyle(
                    color: SakuColors.neutral600,
                    fontSize: 16,
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

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = SakuColors.blue700,
    this.trailing = Icons.chevron_right_rounded,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final IconData trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: SakuColors.neutral300),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 27),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: SakuColors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: SakuColors.neutral300,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(trailing, color: SakuColors.neutral600, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}



class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: SakuColors.neutral300),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.notifications_rounded,
                color: SakuColors.mango500,
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Text(
                  'Notifikasi',
                  style: TextStyle(
                    color: SakuColors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Switch(
                value: true,
                onChanged: (_) => onTap(),
                activeThumbColor: SakuColors.white,
                activeTrackColor: SakuColors.mango500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
