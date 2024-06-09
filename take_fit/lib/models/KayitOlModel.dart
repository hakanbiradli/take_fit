import 'dart:io';

class KayitOlModel {
  final int? id;
  final String? name;
  final String? surname;
  final int? age;
  final int? length;
  final int? kilo;
  final String? username;
  final String? password;
  final String? picture;
  final String? cinsiyet;
  KayitOlModel(
      {required this.id,
      required this.name,
      required this.surname,
      required this.age,
      required this.length,
      required this.kilo,
      required this.username,
      required this.password,
      required this.picture,
      required this.cinsiyet});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'username': username,
      'password': password,
      'picture': picture,
      'length': length,
      'kilo': kilo,
      'age': age,
      'cinsiyet': cinsiyet
    };
  }

  factory KayitOlModel.fromJson(Map<String, dynamic> json) {
    return KayitOlModel(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      password: json['password'],
      picture: json['picture'],
      age: json['age'],
      length: json['length'],
      kilo: json['kilo'],
      cinsiyet: json['cinsiyet'],
    );
  }
}
