import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final int? id;
  final String nama;
  final String email;
  final String? password;
  User({this.id, required this.nama, required this.email, this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'nama': nama, 'email': email, 'password': password};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}