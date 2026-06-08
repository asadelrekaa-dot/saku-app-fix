import 'dart:convert';

class HutangResponseModel {
    final String? status;
    final String? message;
    final Hutang? data;

    HutangResponseModel({
        this.status,
        this.message,
        this.data,
    });

    factory HutangResponseModel.fromJson(String str) => HutangResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory HutangResponseModel.fromMap(Map<String, dynamic> json) => HutangResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Hutang.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data?.toMap(),
    };
}

class Hutang {
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

    Hutang({
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
    });

    factory Hutang.fromJson(String str) => Hutang.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Hutang.fromMap(Map<String, dynamic> json) => Hutang(
        userId: json["user_id"],
        walletId: json["wallet_id"],
        waktu: json["waktu"] == null ? null : DateTime.parse(json["waktu"]),
        nama: json["nama"],
        notes: json["notes"],
        nominal: json["nominal"],
        status: json["status"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
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
    };
}
