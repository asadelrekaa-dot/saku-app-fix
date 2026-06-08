import 'dart:convert';

class WalletRequestModel {
    final String? namaWallet;
    final int? nominal;

    WalletRequestModel({
        this.namaWallet,
        this.nominal,
    });

    factory WalletRequestModel.fromJson(String str) => WalletRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory WalletRequestModel.fromMap(Map<String, dynamic> json) => WalletRequestModel(
        namaWallet: json["nama_wallet"],
        nominal: json["nominal"],
    );

    Map<String, dynamic> toMap() => {
        "nama_wallet": namaWallet,
        "nominal": nominal,
    };
}
