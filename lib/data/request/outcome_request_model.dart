import 'dart:convert';

class OutcomeRequestModel {
    final int? walletId;
    final int? kategoriId;
    final DateTime? waktu;
    final String? notes;
    final int? nominal;

    OutcomeRequestModel({
        this.walletId,
        this.kategoriId,
        this.waktu,
        this.notes,
        this.nominal,
    });

    factory OutcomeRequestModel.fromJson(String str) => OutcomeRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OutcomeRequestModel.fromMap(Map<String, dynamic> json) => OutcomeRequestModel(
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
