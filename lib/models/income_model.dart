class IncomeModel {
  final int? id;
  final int userId;
  final int walletId;
  final int kategoriId;
  final String waktu;
  final String notes;
  final double nominal;
  final String? createdAt;
  final String? updatedAt;

  IncomeModel({
    this.id,
    required this.userId,
    required this.walletId,
    required this.kategoriId,
    required this.waktu,
    required this.notes,
    required this.nominal,
    this.createdAt,
    this.updatedAt,
  });

  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
      id: map['id'],
      userId: map['user_id'],
      walletId: map['wallet_id'],
      kategoriId: map['kategori_id'],
      waktu: map['waktu'],
      notes: map['notes'],
      nominal: double.parse(map['nominal'].toString()),
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'wallet_id': walletId,
      'kategori_id': kategoriId,
      'waktu': waktu,
      'notes': notes,
      'nominal': nominal,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}