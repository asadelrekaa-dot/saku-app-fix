import 'dart:convert';

class CategoryResponseModel {
    final String? status;
    final List<Kategori>? data;

    CategoryResponseModel({
        this.status,
        this.data,
    });

    factory CategoryResponseModel.fromJson(String str) => CategoryResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CategoryResponseModel.fromMap(Map<String, dynamic> json) => CategoryResponseModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Kategori>.from(json["data"]!.map((x) => Kategori.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Kategori {
    final int? id;
    final String? nama;
    final String? statusKategori;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Kategori({
        this.id,
        this.nama,
        this.statusKategori,
        this.createdAt,
        this.updatedAt,
    });

    factory Kategori.fromJson(String str) => Kategori.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Kategori.fromMap(Map<String, dynamic> json) => Kategori(
        id: json["id"],
        nama: json["nama"],
        statusKategori: json["status_kategori"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nama": nama,
        "status_kategori": statusKategori,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
