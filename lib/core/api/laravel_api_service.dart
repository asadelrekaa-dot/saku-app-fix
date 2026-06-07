import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LaravelUser {
  const LaravelUser({
    required this.name,
    required this.email,
  });

  factory LaravelUser.fromJson(Map<String, dynamic> json) {
    return LaravelUser(
      name: (json['name'] ?? 'Pengguna').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }

  final String name;
  final String email;
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
  });

  final String title;
  final String note;
  final int amountValue;
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

  static const _baseUrl = String.fromEnvironment(
    'SAKU_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );
  static const _tokenKey = 'saku_laravel_token';
  static const _walletIdKey = 'saku_laravel_wallet_id';

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
    await ensureDefaultWallet();
    return auth;
  }

  Future<void> logout() async {
    try {
      await _post('/logout', body: const {});
    } catch (_) {
      // Token may already be invalid or the local API may be offline.
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_walletIdKey);
  }

  Future<int> ensureDefaultWallet() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedWalletId = prefs.getInt(_walletIdKey);
    if (cachedWalletId != null) return cachedWalletId;

    final data = await _post(
      '/wallet',
      body: {
        'nama_wallet': 'BSI',
        'nominal': 12000000,
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
      'waktu': DateTime.now().toIso8601String(),
      'notes': item.note,
      'nominal': amount,
    };

    if (apiType == 'income' || apiType == 'outcome') {
      body['kategori_id'] = _categoryId(item.title, item.amountValue > 0);
    } else {
      body['nama'] = _personName(item);
    }

    final data = await _post('/$apiType', body: body);
    final apiId = _readId(data['data']);
    if (apiId == null) {
      throw const LaravelApiException('Response API tidak berisi id data.');
    }

    return SyncedTransaction(apiId: apiId, apiType: apiType);
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

  Future<LaravelAuthResult> _storeAuth(Map<String, dynamic> data) async {
    final token = (data['access_token'] ?? data['token'] ?? '').toString();
    if (token.isEmpty) {
      throw const LaravelApiException('Token auth tidak ditemukan dari API.');
    }

    final userData = data['user'];
    if (userData is! Map<String, dynamic>) {
      throw const LaravelApiException('Data user tidak ditemukan dari API.');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    return LaravelAuthResult(
      token: token,
      user: LaravelUser.fromJson(userData),
    );
  }

  Future<int> _walletId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_walletIdKey) ?? 1;
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
        ? await http.put(_uri(path), headers: headers, body: requestBody)
        : await http.post(_uri(path), headers: headers, body: requestBody);
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
