class NominalWalletModel {
  final int? id;
  final int userId;
  final int walletId;
  final int nominal;
  final String? createdAt;
  final String? updatedAt;

  NominalWalletModel({
    this.id,
    required this.userId,
    required this.walletId,
    required this.nominal,
    this.createdAt,
    this.updatedAt,
  });

  factory NominalWalletModel.fromMap(Map<String, dynamic> map) {
    return NominalWalletModel(
      id: map['id'],
      userId: map['user_id'],
      walletId: map['wallet_id'],
      nominal: map['nominal'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'wallet_id': walletId,
      'nominal': nominal,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}