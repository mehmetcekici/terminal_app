import 'dart:convert';

class Transaction {
  Transaction({
    this.id,
    this.pin,
    this.date,
    this.islem,
  });

  int id;
  int pin;
  String date;
  int islem;

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
        id: map["ID"],
        pin: map["PIN"],
        date: map["DATE"],
        islem: map["ISLEM"],
      );

  Map<String, dynamic> toMap() =>
      {"ID": id, "PIN": pin, "DATE": date, "ISLEM": islem};

  static List<Transaction> fromListMap(List<Map<String, dynamic>> mapList) =>
      List<Transaction>.from(mapList.map((x) => Transaction.fromMap(x)));

  static String toListMap(List<Transaction> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

  static String toStr(Transaction transaction) {
    return transaction.pin.toString() +
        "#" +
        transaction.date +
        "#" +
        transaction.islem.toString();
  }

  static String listToString(List<Transaction> list) {
    var str = "";
    for (var i = 0; i < list.length; i++) {
      str += toStr(list[i]) + "\n";
    }
    return str;
  }
}
