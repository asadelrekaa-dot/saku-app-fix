import 'dart:convert';

class BeriPinjamanRequestModel {
  final int? walletId;
  final DateTime? waktu;
  final String? nama;
  final String? notes;
  final int? nominal;
  final DateTime? deadline;

  BeriPinjamanRequestModel({
    this.walletId,
    this.waktu,
    this.nama,
    this.notes,
    this.nominal,
    this.deadline,
  });

  factory BeriPinjamanRequestModel.fromJson(String str) =>
      BeriPinjamanRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BeriPinjamanRequestModel.fromMap(Map<String, dynamic> json) =>
      BeriPinjamanRequestModel(
        walletId: json["wallet_id"],
        waktu: json["waktu"] == null ? null : DateTime.parse(json["waktu"]),
        nama: json["nama"],
        notes: json["notes"],
        nominal: json["nominal"],
        deadline: json["deadline"] == null
            ? null
            : DateTime.parse(json["deadline"]),
      );

  Map<String, dynamic> toMap() => {
        "wallet_id": walletId,
        "waktu": waktu?.toIso8601String(),
        "nama": nama,
        "notes": notes,
        "nominal": nominal,
        "deadline": deadline?.toIso8601String(),
      };
}