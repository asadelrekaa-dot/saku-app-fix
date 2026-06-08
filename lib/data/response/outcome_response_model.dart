import 'dart:convert';

class OutcomeResponseModel {
    final String? status;
    final String? message;
    final Outcome? data;

    OutcomeResponseModel({
        this.status,
        this.message,
        this.data,
    });

    factory OutcomeResponseModel.fromJson(String str) => OutcomeResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OutcomeResponseModel.fromMap(Map<String, dynamic> json) => OutcomeResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Outcome.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data?.toMap(),
    };
}

class Outcome {
    final int? userId;
    final int? walletId;
    final int? kategoriId;
    final DateTime? waktu;
    final String? notes;
    final int? nominal;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    Outcome({
        this.userId,
        this.walletId,
        this.kategoriId,
        this.waktu,
        this.notes,
        this.nominal,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory Outcome.fromJson(String str) => Outcome.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Outcome.fromMap(Map<String, dynamic> json) => Outcome(
        userId: json["user_id"],
        walletId: json["wallet_id"],
        kategoriId: json["kategori_id"],
        waktu: json["waktu"] == null ? null : DateTime.parse(json["waktu"]),
        notes: json["notes"],
        nominal: json["nominal"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "user_id": userId,
        "wallet_id": walletId,
        "kategori_id": kategoriId,
        "waktu": waktu?.toIso8601String(),
        "notes": notes,
        "nominal": nominal,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
