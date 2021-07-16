import 'dart:convert';

class User {
  User(
      {this.id,
      this.islem,
      this.pin,
      this.kisi,
      this.birim,
      this.plaka,
      this.admin,
      this.kartdec,
      this.karthex,
      this.kartthex,
      this.face});

  int id;
  String islem;
  int pin;
  String kisi;
  String birim;
  String plaka;
  int admin;
  String kartdec;
  String karthex;
  String kartthex;
  List face;

  factory User.fromJson(Map<String, dynamic> json) => User(
        islem: json["ISLEM"],
        pin: int.parse(json["PIN"]),
        kisi: json["KISI"],
        birim: json["BIRIM"],
        plaka: json["PLAKA"],
        admin: int.parse(json["ADMIN"]),
        kartdec: json["KARTDEC"],
        karthex: json["KARTHEX"],
        kartthex: json["KARTTHEX"],
        face: json["FACE"],
      );

  factory User.fromSqfLite(Map<String, dynamic> map) => User(
        id: map["ID"],
        pin: map["PIN"],
        kisi: map["KISI"],
        birim: map["BIRIM"],
        plaka: map["PLAKA"],
        admin: map["ADMIN"],
        kartdec: map["KARTDEC"],
        karthex: map["KARTHEX"],
        kartthex: map["KARTTHEX"],
        face: json.decode(map["FACE"]),
      );

  Map<String, dynamic> toMapForSqfLite() => {
        "ID": id,
        "PIN": pin,
        "KISI": kisi,
        "BIRIM": birim,
        "PLAKA": plaka,
        "ADMIN": admin,
        "KARTDEC": kartdec,
        "KARTHEX": karthex,
        "KARTTHEX": kartthex,
        "FACE": face.toString(),
      };

  static List<User> fromJsonList(String str) =>
      List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

  static List<User> fromSqfLiteList(List<Map<String, dynamic>> mapList) =>
      List<User>.from(mapList.map((x) => User.fromSqfLite(x)));

  static String toMapForSqfLiteList(List<User> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toMapForSqfLite())));
}
