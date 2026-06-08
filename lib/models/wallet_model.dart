class WalletModel {
  final int? id;
  final int userId;
  final String namaWallet;
  final String? createdAt;
  final String? updatedAt;

  WalletModel({
    this.id,
    required this.userId,
    required this.namaWallet,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'],
      userId: map['user_id'],
      namaWallet: map['nama_wallet'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'nama_wallet': namaWallet,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}