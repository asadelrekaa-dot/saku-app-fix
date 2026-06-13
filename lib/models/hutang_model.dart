class HutangModel {
  final int? id;
  final int userId;
  final int walletId;
  final String waktu;
  final String nama;
  final String? catatan;
  final int nominal;
  final String status;
  final String? deadline;
  final String? createdAt;
  final String? updatedAt;

  HutangModel({
    this.id,
    required this.userId,
    required this.walletId,
    required this.waktu,
    required this.nama,
    this.catatan,
    required this.nominal,
    required this.status,
    this.deadline,
    this.createdAt,
    this.updatedAt,
  });

  factory HutangModel.fromMap(Map<String, dynamic> map) {
    return HutangModel(
      id: map['id'],
      userId: map['user_id'],
      walletId: map['wallet_id'],
      waktu: map['waktu'],
      nama: map['nama'],
      catatan: map['catatan'],
      nominal: map['nominal'],
      status: map['status'],
      deadline: map['deadline'], 
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
      'deadline': deadline,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}