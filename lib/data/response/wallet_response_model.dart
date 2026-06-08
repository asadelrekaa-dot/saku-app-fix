import 'dart:convert';

class WalletResponseModel {
    final String? status;
    final Wallet? data;

    WalletResponseModel({
        this.status,
        this.data,
    });

    factory WalletResponseModel.fromJson(String str) => WalletResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory WalletResponseModel.fromMap(Map<String, dynamic> json) => WalletResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Wallet.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
    };
}

class Wallet {
    final int? userId;
    final String? namaWallet;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    Wallet({
        this.userId,
        this.namaWallet,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory Wallet.fromJson(String str) => Wallet.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Wallet.fromMap(Map<String, dynamic> json) => Wallet(
        userId: json["user_id"],
        namaWallet: json["nama_wallet"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "user_id": userId,
        "nama_wallet": namaWallet,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
