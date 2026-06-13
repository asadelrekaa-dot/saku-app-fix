import 'dart:convert';

class BeriPinjamanResponseModel {
  final String? status;
  final String? message;
  final BeriPinjaman? data;

  BeriPinjamanResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory BeriPinjamanResponseModel.fromJson(String str) =>
      BeriPinjamanResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BeriPinjamanResponseModel.fromMap(Map<String, dynamic> json) =>
      BeriPinjamanResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : BeriPinjaman.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data?.toMap(),
      };
}

class BeriPinjaman {
  final int? userId;
  final int? walletId;
  final DateTime? waktu;
  final String? nama;
  final String? notes;
  final int? nominal;
  final String? status;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;
  final Deadline? deadline;

  BeriPinjaman({
    this.userId,
    this.walletId,
    this.waktu,
    this.nama,
    this.notes,
    this.nominal,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.deadline,
  });

  factory BeriPinjaman.fromJson(String str) =>
      BeriPinjaman.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BeriPinjaman.fromMap(Map<String, dynamic> json) => BeriPinjaman(
        userId: json["user_id"],
        walletId: json["wallet_id"],
        waktu: json["waktu"] == null ? null : DateTime.parse(json["waktu"]),
        nama: json["nama"],
        notes: json["notes"],
        nominal: json["nominal"],
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        deadline: json["deadline"] == null
            ? null
            : Deadline.fromMap(json["deadline"]),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "wallet_id": walletId,
        "waktu": waktu?.toIso8601String(),
        "nama": nama,
        "notes": notes,
        "nominal": nominal,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "deadline": deadline?.toMap(),
      };
}

class Deadline {
  final int? id;
  final int? beriPinjamanId;
  final DateTime? deadline;

  Deadline({
    this.id,
    this.beriPinjamanId,
    this.deadline,
  });

  factory Deadline.fromMap(Map<String, dynamic> json) => Deadline(
        id: json["id"],
        beriPinjamanId: json["beri_pinjaman_id"],
        deadline:
            json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "beri_pinjaman_id": beriPinjamanId,
        "deadline": deadline?.toIso8601String(),
      };
}
