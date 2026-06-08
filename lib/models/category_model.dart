class CategoryModel {
  final int? id;
  final String nama;
  final String statusKategori;
  final String? createdAt;
  final String? updatedAt;

  CategoryModel({
    this.id,
    required this.nama,
    required this.statusKategori,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      nama: map['nama'],
      statusKategori: map['status_kategori'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'status_kategori': statusKategori,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}