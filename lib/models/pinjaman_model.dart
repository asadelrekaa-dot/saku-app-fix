class PinjamanModel {
  final int? id;
  final int userId;
  final int walletId;
  final String waktu;
  final String nama;
  final String? catatan;
  final int nominal;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  PinjamanModel({
    this.id,
    required this.userId,
    required this.walletId,
    required this.waktu,
    required this.nama,
    this.catatan,
    required this.nominal,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PinjamanModel.fromMap(Map<String, dynamic> map) {
    return PinjamanModel(
      id: map['id'],
      userId: map['user_id'],
      walletId: map['wallet_id'],
      waktu: map['waktu'],
      nama: map['nama'],
      catatan: map['catatan'],
      nominal: map['nominal'],
      status: map['status'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'wallet_id': walletId,
      'waktu': waktu,
      'nama': nama,
      'catatan': catatan,
      'nominal': nominal,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}