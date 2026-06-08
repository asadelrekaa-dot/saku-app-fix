import 'dart:convert';

class IncomeRequestModel {
    final int? walletId;
    final int? kategoriId;
    final DateTime? waktu;
    final String? notes;
    final int? nominal;

    IncomeRequestModel({
        this.walletId,
        this.kategoriId,
        this.waktu,
        this.notes,
        this.nominal,
    });

    factory IncomeRequestModel.fromJson(String str) => IncomeRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory IncomeRequestModel.fromMap(Map<String, dynamic> json) => IncomeRequestModel(
        walletId: json["wallet_id"],
        kategoriId: json["kategori_id"],
        waktu: json["waktu"] == null ? null : DateTime.parse(json["waktu"]),
        notes: json["notes"],
        nominal: json["nominal"],
    );

    Map<String, dynamic> toMap() => {
        "wallet_id": walletId,
        "kategori_id": kategoriId,
        "waktu": waktu?.toIso8601String(),
        "notes": notes,
        "nominal": nominal,
    };
}
