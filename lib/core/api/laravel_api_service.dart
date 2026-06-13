import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dashboard_models.dart' show WalletItem;

class LaravelUser {
  const LaravelUser({
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory LaravelUser.fromJson(Map<String, dynamic> json) {
    return LaravelUser(
      name: (json['name'] ?? 'Pengguna').toString(),
      email: (json['email'] ?? '').toString(),
      photoUrl: (json['photo_url'] as String?),
    );
  }

  final String name;
  final String email;
  final String? photoUrl;
}

class LaravelAuthResult {
  const LaravelAuthResult({
    required this.token,
    required this.user,
  });

  final String token;
  final LaravelUser user;
}

class SyncedTransaction {
  const SyncedTransaction({
    required this.apiId,
    required this.apiType,
  });

  final int apiId;
  final String apiType;
}

class LaravelTransactionDraft {
  const LaravelTransactionDraft({
    required this.title,
    required this.note,
    required this.amountValue,
    this.rawDate,
    this.deadline,
  });

  final String title;
  final String note;
  final int amountValue;
  final String? rawDate;
  final String? deadline;
}

class LaravelApiException implements Exception {
  const LaravelApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LaravelApiService {
  LaravelApiService._();

  static final LaravelApiService instance = LaravelApiService._();

  // ── Ganti IP ini sesuai jaringan kamu saat testing di HP ──
  static const _overrideUrl = "https://decrease-boasting-fanciness.ngrok-free.dev/api";
  // ── Atau override via: flutter run --dart-define=SAKU_API_BASE_URL=... ──

  static const _baseUrl = String.fromEnvironment(
    'SAKU_API_BASE_URL',
    defaultValue: _overrideUrl,
  );
  static const _tokenKey = 'saku_laravel_token';
  static const _walletIdKey = 'saku_laravel_wallet_id';
  static const _userNameKey = 'saku_user_name';
  static const _userEmailKey = 'saku_user_email';

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<LaravelAuthResult> login({
    required String email,
    required String password,
  }) async {
    final data = await _post(
      '/login',
      body: {
        'email': email,
        'password': password,
      },
      authorized: false,
    );
    return _storeAuth(data);
  }

  Future<LaravelAuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _post(
      '/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
      authorized: false,
    );
    final auth = await _storeAuth(data);
    return auth;
  }

  Future<void> logout() async {
    try {
      await _post('/logout', body: const {});
    } catch (e, s) {
      log('[LaravelApiService] logout error', error: e, stackTrace: s);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_walletIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }

  Future<LaravelUser> getProfile() async {
    final data = await _get('/user');
    return LaravelUser.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<void> saveUserLocally({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    await _put('/user', body: {'name': name, 'email': email});
    await saveUserLocally(name: name, email: email);
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _put('/user/password', body: {
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': newPassword,
    });
  }

  Future<String> uploadPhoto(File image) async {
    final data = await _uploadMultipart('/user/photo', image);
    return (data['data'] as Map<String, dynamic>?)?['photo_url']?.toString() ?? '';
  }

  Future<List<WalletItem>> getWallets() async {
    final data = await _get('/wallets');
    final list = data['data'];
    if (list is! List) return [];
    return list.map((e) {
      final map = e as Map<String, dynamic>;
      return WalletItem(
        id: map['id'] as int?,
        name: (map['nama_wallet'] ?? 'Dompet').toString(),
        balance: int.tryParse((map['nominal'] ?? '0').toString()) ?? 0,
      );
    }).toList();
  }

  Future<WalletItem> createWallet({
    required String name,
    required int balance,
    bool isPrimary = false,
  }) async {
    final data = await _post('/wallet', body: {
      'nama_wallet': name,
      'nominal': balance,
      if (isPrimary) 'is_primary': true,
    });
    final item = data['data'] as Map<String, dynamic>;
    return WalletItem(
      id: item['id'] as int?,
      name: (item['nama_wallet'] ?? name).toString(),
      balance: int.tryParse((item['nominal'] ?? balance).toString()) ?? balance,
    );
  }

  Future<void> deleteWallet({required int id}) async {
    await _delete('/wallets/$id');
  }

  Future<String> chatWithAi({
    required String message,
    List<Map<String, String>>? history,
    Map<String, dynamic>? context,
  }) async {
    final data = await _post('/ai/chat', body: {
      'message': message,
      if (history != null) 'history': history,
      if (context != null) 'context': context,
    });
    return data['reply'] as String? ?? '';
  }

  Future<WalletItem> updateWallet({
    required int id,
    required String name,
    bool isPrimary = false,
  }) async {
    final data = await _put('/wallets/$id', body: {
      'nama_wallet': name,
      if (isPrimary) 'is_primary': true,
    });
    final item = data['data'] as Map<String, dynamic>;
    return WalletItem(
      id: item['id'] as int? ?? id,
      name: (item['nama_wallet'] ?? name).toString(),
      balance: int.tryParse((item['nominal'] ?? '0').toString()) ?? 0,
    );
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    final data = await _get('/budgets');
    final list = data['data'];
    if (list is! List) return [];
    return list.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createBudget({
    required int kategoriId,
    required int nominal,
  }) async {
    final data = await _post('/budgets', body: {
      'kategori_id': kategoriId,
      'nominal': nominal,
    });
    return (data['data'] as Map<String, dynamic>?) ?? {};
  }

  Future<void> deleteBudget({required int apiId}) async {
    await _delete('/budgets/$apiId');
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final data = await _get('/transactions');
    final list = data['data'];
    if (list is! List) return [];
    return list.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final data = await _get('/notifications');
    final list = data['data'];
    if (list is! List) return [];
    return list.cast<Map<String, dynamic>>();
  }

  Future<int> ensureDefaultWallet() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedWalletId = prefs.getInt(_walletIdKey);
    if (cachedWalletId != null) return cachedWalletId;

    final data = await _post(
      '/wallet',
      body: {
        'nama_wallet': 'Dompet Utama',
        'nominal': 0,
      },
    );
    final walletId = _readId(data['data']) ?? 1;
    await prefs.setInt(_walletIdKey, walletId);
    return walletId;
  }

  Future<SyncedTransaction> createTransaction(
    LaravelTransactionDraft item,
  ) async {
    final apiType = _apiTypeFor(item);
    final walletId = await _walletId();
    final amount = item.amountValue.abs();
    final body = <String, Object?>{
      'wallet_id': walletId,
      'waktu': item.rawDate ?? DateTime.now().toIso8601String(),
      'notes': item.note,
      'nominal': amount,
    };

    if (apiType == 'income' || apiType == 'outcome') {
      body['kategori_id'] = _categoryId(item.title, item.amountValue > 0);
    } else {
      body['nama'] = _personName(item);
      body['deadline'] = item.deadline ?? DateTime.now().add(const Duration(days: 30)).toIso8601String();
    }

    final data = await _post('/$apiType', body: body);
    final apiId = _readId(data['data']);
    if (apiId == null) {
      throw const LaravelApiException('Response API tidak berisi id data.');
    }

    return SyncedTransaction(apiId: apiId, apiType: apiType);
  }

  Future<void> deleteTransaction({
    required int? apiId,
    required String? apiType,
  }) async {
    if (apiId == null || apiType == null) return;
    await _delete('/$apiType/$apiId');
  }

  Future<void> updateTransaction({
    required int? apiId,
    required String? apiType,
    required LaravelTransactionDraft item,
  }) async {
    if (apiId == null || apiType == null) return;
    final walletId = await _walletId();
    final amount = item.amountValue.abs();
    final body = <String, Object?>{
      'wallet_id': walletId,
      'waktu': item.rawDate ?? DateTime.now().toIso8601String(),
      'notes': item.note,
      'nominal': amount,
    };

    if (apiType == 'income' || apiType == 'outcome') {
      body['kategori_id'] = _categoryId(item.title, item.amountValue > 0);
    } else {
      body['nama'] = _personName(item);
      body['deadline'] = item.deadline ?? DateTime.now().add(const Duration(days: 30)).toIso8601String();
    }

    await _put('/$apiType/$apiId', body: body);
  }

  Future<void> markSettled({
    required int? apiId,
    required String? apiType,
  }) async {
    if (apiId == null || apiType == null) return;
    if (apiType != 'hutang' && apiType != 'beri-pinjaman') return;

    await _put(
      '/$apiType/$apiId',
      body: {'status': 'paid'},
    );
  }

  Future<({String name, String email})?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;
    final name = prefs.getString(_userNameKey) ?? 'Pengguna';
    final email = prefs.getString(_userEmailKey) ?? '';
    return (name: name, email: email);
  }

  Future<LaravelAuthResult> _storeAuth(Map<String, dynamic> data) async {
    final token = (data['access_token'] ?? data['token'] ?? '').toString();
    if (token.isEmpty) {
      throw const LaravelApiException('Token auth tidak ditemukan dari API.');
    }

    final userData = data['user'];
    if (userData is! Map<String, dynamic>) {
      throw const LaravelApiException('Data user tidak ditemukan dari API.');
    }

    final user = LaravelUser.fromJson(userData);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userNameKey, user.name);
    await prefs.setString(_userEmailKey, user.email);
    return LaravelAuthResult(
      token: token,
      user: user,
    );
  }

  Future<void> cacheWalletId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_walletIdKey, id);
  }

  Future<int> _walletId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_walletIdKey) ?? 1;
  }

  Future<int> getWalletId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_walletIdKey) ?? 1;
  }

  Future<Map<String, dynamic>> _uploadMultipart(
    String path,
    File file,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final request = http.MultipartRequest('POST', _uri(path));
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Accept'] = 'application/json';
    request.files.add(await http.MultipartFile.fromPath('photo', file.path));
    final streamed = await request.send().timeout(const Duration(seconds: 60));
    final response = await http.Response.fromStream(streamed);
    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LaravelApiException(
        _messageFrom(decoded) ?? 'API error ${response.statusCode}',
      );
    }
    return decoded;
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http
        .get(_uri(path), headers: headers)
        .timeout(const Duration(seconds: 30));
    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LaravelApiException(
        _messageFrom(decoded) ?? 'API error ${response.statusCode}',
      );
    }
    return decoded;
  }

  Future<void> _delete(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http
        .delete(_uri(path), headers: headers)
        .timeout(const Duration(seconds: 30));
    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LaravelApiException(
        _messageFrom(decoded) ?? 'API error ${response.statusCode}',
      );
    }
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    required Map<String, Object?> body,
    bool authorized = true,
  }) {
    return _send('POST', path, body: body, authorized: authorized);
  }

  Future<Map<String, dynamic>> _put(
    String path, {
    required Map<String, Object?> body,
  }) {
    return _send('PUT', path, body: body);
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    required Map<String, Object?> body,
    bool authorized = true,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authorized) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final requestBody = jsonEncode(body);
    final response = method == 'PUT'
        ? await http
            .put(_uri(path), headers: headers, body: requestBody)
            .timeout(const Duration(seconds: 30))
        : await http
            .post(_uri(path), headers: headers, body: requestBody)
            .timeout(const Duration(seconds: 30));
    final decoded = _decode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LaravelApiException(
        _messageFrom(decoded) ?? 'API error ${response.statusCode}',
      );
    }

    return decoded;
  }

  Map<String, dynamic> _decode(String source) {
    if (source.trim().isEmpty) return {};
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) return decoded;
    throw const LaravelApiException('Format response API tidak sesuai.');
  }

  String? _messageFrom(Map<String, dynamic> data) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;

    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
      return first.toString();
    }

    return null;
  }

  int? _readId(Object? data) {
    if (data is Map<String, dynamic>) {
      final id = data['id'];
      if (id is int) return id;
      return int.tryParse(id?.toString() ?? '');
    }
    return null;
  }

  String _apiTypeFor(LaravelTransactionDraft item) {
    if (item.title == 'Hutang') return 'hutang';
    if (item.title == 'Beri Pinjaman') return 'beri-pinjaman';
    return item.amountValue > 0 ? 'income' : 'outcome';
  }

  String _personName(LaravelTransactionDraft item) {
    final name = item.note
        .replaceFirst(RegExp(r'^Pinjaman ke\s+', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^Hutang ke\s+', caseSensitive: false), '')
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .take(2)
        .join(' ');
    return name.isEmpty ? 'Nama' : name;
  }

  int _categoryId(String title, bool income) {
    final normalized = title.toLowerCase();
    final categories = income ? _incomeCategoryIds : _outcomeCategoryIds;
    return categories[normalized] ?? categories['lainnya'] ?? 1;
  }
}

const _outcomeCategoryIds = {
  'makanan': 1,
  'transportasi': 2,
  'rumah': 3,
  'kesehatan': 4,
  'belanja': 5,
  'kecantikan': 6,
  'hiburan': 7,
  'pendidikan': 8,
  'olahraga': 9,
  'sedekah': 10,
  'darurat': 11,
  'lainnya': 12,
};

const _incomeCategoryIds = {
  'gaji': 13,
  'freelance': 14,
  'bisnis': 15,
  'penjualan': 16,
  'investasi': 17,
  'hadiah': 18,
  'sewa': 19,
  'uang saku': 20,
  'uangsaku': 20,
  'lainnya': 21,
};
