import 'package:saku_pengeluaran/models/category_model.dart';
import 'package:saku_pengeluaran/models/nominal_wallet.dart';
import 'package:saku_pengeluaran/models/wallet_model.dart';
import 'package:saku_pengeluaran/models/hutang_model.dart';
import 'package:saku_pengeluaran/models/pinjaman_model.dart';
import 'package:saku_pengeluaran/models/income_model.dart';
import 'package:saku_pengeluaran/models/outcome_model.dart';
import 'package:sqflite/sqflite.dart';

class TransactionLocalDatasource {
  TransactionLocalDatasource._init();
  static final TransactionLocalDatasource instance =
      TransactionLocalDatasource._init();

  final String tableCategory = 'category';
  final String tableWallet = 'wallet';
  final String tableIncome = 'income';
  final String tableOutcome = 'outcome';
  final String tableHutang = 'hutang';
  final String tablePinjaman = 'pinjaman';
  final String tableNominalWallet = 'nominal_wallet';

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCategory (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama TEXT NOT NULL,
      status_kategori TEXT NOT NULL,
      created_at TEXT,
      updated_at TEXT
      )
''');

    await db.execute('''
      CREATE TABLE $tableWallet (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      nama_wallet TEXT NOT NULL,
      created_at TEXT,
      updated_at TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableIncome (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      wallet_id INTEGER,
      kategori_id INTEGER,
      waktu DATETIME,
      notes TEXT,
      nominal INTEGER,
      created_at TEXT,
      updated_at TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableOutcome (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      wallet_id INTEGER,
      kategori_id INTEGER,
      waktu DATETIME,
      notes TEXT,
      nominal INTEGER,
      created_at TEXT,
      updated_at TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE $tableHutang (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      wallet_id INTEGER,
      waktu DATETIME,
      nama TEXT,
      catatan TEXT,
      nominal INTEGER,
      status TEXT,
      created_at TEXT,
      updated_at TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE $tablePinjaman (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      wallet_id INTEGER,
      waktu DATETIME,
      nama TEXT,
      catatan TEXT,
      nominal INTEGER,
      status TEXT,
      created_at TEXT,
      updated_at TEXT
      )
      ''');

    await db.execute('''
    CREATE TABLE $tableNominalWallet (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    wallet_id INTEGER,
    nominal INTEGER,
    created_at TEXT,
    updated_at TEXT
  )
''');
  }

  static Database? _database;

  Future<Database> _initDB() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/saku.db';

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // ==================== INCOME ====================

  Future<int> insertIncome(IncomeModel income) async {
    final db = await database;

    return await db.insert(
      tableIncome,
      income.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<IncomeModel>> getAllIncome() async {
    final db = await database;

    final result = await db.query(
      tableIncome,
      orderBy: 'waktu DESC',
    );

    return result.map((e) => IncomeModel.fromMap(e)).toList();
  }

  Future<int> updateIncome(IncomeModel income) async {
    final db = await database;

    return await db.update(
      tableIncome,
      income.toMap(),
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  Future<int> deleteIncome(int id) async {
    final db = await database;

    return await db.delete(
      tableIncome,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// ==================== OUTCOME ====================

  Future<int> insertOutcome(OutcomeModel outcome) async {
    final db = await database;

    return await db.insert(
      tableOutcome,
      outcome.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<OutcomeModel>> getAllOutcome() async {
    final db = await database;

    final result = await db.query(
      tableOutcome,
      orderBy: 'waktu DESC',
    );

    return result.map((e) => OutcomeModel.fromMap(e)).toList();
  }

  Future<int> updateOutcome(OutcomeModel outcome) async {
    final db = await database;

    return await db.update(
      tableOutcome,
      outcome.toMap(),
      where: 'id = ?',
      whereArgs: [outcome.id],
    );
  }

  Future<int> deleteOutcome(int id) async {
    final db = await database;

    return await db.delete(
      tableOutcome,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== WALLET ====================

Future<int> insertWallet(WalletModel wallet) async {
  final db = await database;

  return await db.insert(
    tableWallet,
    wallet.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<WalletModel>> getAllWallet() async {
  final db = await database;

  final result = await db.query(tableWallet);

  return result.map((e) => WalletModel.fromMap(e)).toList();
}

Future<int> updateWallet(WalletModel wallet) async {
  final db = await database;

  return await db.update(
    tableWallet,
    wallet.toMap(),
    where: 'id = ?',
    whereArgs: [wallet.id],
  );
}

Future<int> deleteWallet(int id) async {
  final db = await database;

  return await db.delete(
    tableWallet,
    where: 'id = ?',
    whereArgs: [id],
  );
}

// ==================== NOMINAL WALLET ====================

Future<int> insertNominalWallet(
  NominalWalletModel nominalWallet,
) async {
  final db = await database;

  return await db.insert(
    tableNominalWallet,
    nominalWallet.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<NominalWalletModel>> getAllNominalWallet() async {
  final db = await database;

  final result = await db.query(tableNominalWallet);

  return result
      .map((e) => NominalWalletModel.fromMap(e))
      .toList();
}

Future<int> updateNominalWallet(
  NominalWalletModel nominalWallet,
) async {
  final db = await database;

  return await db.update(
    tableNominalWallet,
    nominalWallet.toMap(),
    where: 'id = ?',
    whereArgs: [nominalWallet.id],
  );
}

Future<int> deleteNominalWallet(int id) async {
  final db = await database;

  return await db.delete(
    tableNominalWallet,
    where: 'id = ?',
    whereArgs: [id],
  );
}

// ==================== HUTANG ====================

Future<int> insertHutang(HutangModel hutang) async {
  final db = await database;

  return await db.insert(
    tableHutang,
    hutang.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<HutangModel>> getAllHutang() async {
  final db = await database;

  final result = await db.query(
    tableHutang,
    orderBy: 'waktu DESC',
  );

  return result.map((e) => HutangModel.fromMap(e)).toList();
}

Future<int> updateHutang(HutangModel hutang) async {
  final db = await database;

  return await db.update(
    tableHutang,
    hutang.toMap(),
    where: 'id = ?',
    whereArgs: [hutang.id],
  );
}

Future<int> deleteHutang(int id) async {
  final db = await database;

  return await db.delete(
    tableHutang,
    where: 'id = ?',
    whereArgs: [id],
  );
}

// ==================== PINJAMAN ====================

Future<int> insertPinjaman(PinjamanModel pinjaman) async {
  final db = await database;

  return await db.insert(
    tablePinjaman,
    pinjaman.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<PinjamanModel>> getAllPinjaman() async {
  final db = await database;

  final result = await db.query(
    tablePinjaman,
    orderBy: 'waktu DESC',
  );

  return result.map((e) => PinjamanModel.fromMap(e)).toList();
}

Future<int> updatePinjaman(PinjamanModel pinjaman) async {
  final db = await database;

  return await db.update(
    tablePinjaman,
    pinjaman.toMap(),
    where: 'id = ?',
    whereArgs: [pinjaman.id],
  );
}

Future<int> deletePinjaman(int id) async {
  final db = await database;

  return await db.delete(
    tablePinjaman,
    where: 'id = ?',
    whereArgs: [id],
  );
}

// ==================== CATEGORY ====================

Future<List<CategoryModel>> getAllCategory() async {
  final db = await database;

  final result = await db.query(tableCategory);

  return result.map((e) => CategoryModel.fromMap(e)).toList();
}
}
