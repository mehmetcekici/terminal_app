import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:terminal_app/entities/transaction.dart';
import 'package:terminal_app/services/device/db_service.dart';
import 'package:terminal_app/services/device/device_info_service.dart';
import 'package:terminal_app/services/device/shared_pref_service.dart';
import 'package:terminal_app/services/device/toast_service.dart';

class TransactionService {
  static final table = "Transactions";

  static Future<List<Transaction>> getAll() async {
    var db = DbService.instance;
    var result = await db.select(table);
    return Transaction.fromListMap(result);
  }

  static Future<Transaction> getById(int id) async {
    var db = DbService.instance;

    var result = await db.select(
      table,
      where: "ID = ?",
      whereArgs: [id],
    );
    return Transaction.fromListMap(result).first;
  }

  static Future<List<Transaction>> getByPin(int pin) async {
    var db = DbService.instance;
    var query = await db.select(
      table,
      where: "PIN = ?",
      whereArgs: [pin],
    );
    return Transaction.fromListMap(query);
  }

  static Future<int> add(int pin, int islem) async {
    Transaction transaction = Transaction();
    DateTime now = new DateTime.now();
    transaction.date = DateFormat("dd.MM.yyyy HH:mm").format(now);
    transaction.pin = pin;
    transaction.islem = islem;
    var db = DbService.instance;
    return db.insert(
      table,
      transaction.toMap(),
    );
  }

  static Future<int> update(Transaction transaction) async {
    var db = DbService.instance;
    return db.update(
      table,
      transaction.id,
      transaction.toMap(),
    );
  }

  static Future<int> delete(int id) async {
    var db = DbService.instance;
    return db.delete(table, id);
  }

  static Future<int> count() {
    var db = DbService.instance;
    return db.count(table);
  }

  static Future<bool> uploadData() async {
    var deviceId = await DeviceInfoService.getId();
    var server = await SharedPrefService.getString("serverUrl");
    var url = "$server/iclock/androidhar.aspx?SN=$deviceId";
    var list = await getAll();
    if (list != null && list.length > 0) {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: Transaction.listToString(list),
      );
      if (response.statusCode == 200 && response.body == "sonuc") {
        for (int i = 0; i < list.length; i++) {
          delete(list[i].id);
        }
        ToastService.show("Veriler Gönderildi");
        return true;
      }
    }
    return false;
  }
}
