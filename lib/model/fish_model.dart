// DIGUNAKAN UNTUK GET ALL DATA
class FishModel {
  final String id;
  final String namaIkan;
  final String jenisIkan;
  final String hargaIkan;
  final String jenisKelamin;

  FishModel({
    required this.id,
    required this.namaIkan,
    required this.jenisIkan,
    required this.hargaIkan,
    required this.jenisKelamin,
  });

  factory FishModel.fromJson(Map<String, dynamic> json) => FishModel(
        id: json["betta_id"],
        namaIkan: json["nama_betta"],
        jenisIkan: json["jenis_betta"],
        hargaIkan: json["harga_ikan"],
        jenisKelamin: json["jenis_kelamin"],
      );

  Map<String, dynamic> toJson() => {
        "betta_id": id,
        "nama_betta": namaIkan,
        "jenis_betta": jenisIkan,
        "harga_ikan": hargaIkan,
        "jenis_kelamin": jenisKelamin,
      };
}

// DIGUNAKAN UNTUK FORM INPUT
class FishInput {
  final String namaIkan;
  final String jenisIkan;
  final String hargaIkan;
  final String jenisKelamin;

  FishInput({
    required this.namaIkan,
    required this.jenisIkan,
    required this.hargaIkan,
    required this.jenisKelamin,
  });

  Map<String, dynamic> toJson() => {
        "nama_betta": namaIkan,
        "jenis_betta": jenisIkan,
        "harga_ikan": hargaIkan,
        "jenis_kelamin": jenisKelamin,
      };
}

// DIGUNAKAN UNTUK RESPONSE
class FishResponse {
  final String? insertedId;
  final String message;
  final int status;

  FishResponse({
    this.insertedId,
    required this.message,
    required this.status,
  });

  factory FishResponse.fromJson(Map<String, dynamic> json) => FishResponse(
        insertedId: json["inserted_id"],
        message: json["message"],
        status: json["status"],
      );
}
