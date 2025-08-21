import 'dart:convert';

class Kehadiran {
  final int? idKehadiran;
  final int userId;
  final String nama;
  final String tanggal;
  final String kelas;
  final String? status;

  Kehadiran({
    this.idKehadiran,
    required this.userId,
    required this.nama,
    required this.tanggal,
    required this.kelas,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_kehadiran': idKehadiran,
      'userId': userId,
      'nama': nama,
      'tanggal': tanggal,
      'kelas': kelas,
      'status': status,
    };
  }

  factory Kehadiran.fromMap(Map<String, dynamic> map) {
    return Kehadiran(
      idKehadiran: map['id_kehadiran'] as int,
      userId: map['userId'],
      nama: map['nama'] as String,
      tanggal: map['tanggal'] as String,
      kelas: map['kelas'] as String,
      status: map['status'] as String,
    );
  }
  
  String toJson() => json.encode(toMap());

  factory Kehadiran.fromJson(String source) =>
      Kehadiran.fromMap(json.decode(source) as Map<String, dynamic>);
}