import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:terminal_app/entities/transaction.dart';
import 'package:terminal_app/utils/db_helper.dart';
import 'package:terminal_app/utils/device_info.dart';
import 'package:terminal_app/utils/shared_pref.dart';
import 'package:terminal_app/utils/toast_message.dart';

class TransactionService {
  static final table = "Transactions";

  static Future<List<Transaction>> getAll() async {
    var db = DbHelper.instance;
    var result = await db.select(table);
    return Transaction.fromListMap(result);
  }

  static Future<Transaction> getById(int id) async {
    var db = DbHelper.instance;

    var result = await db.select(table, where: "ID = ?", whereArgs: [id]);
    return Transaction.fromListMap(result).first;
  }

  static Future<List<Transaction>> getByPin(int pin) async {
    var db = DbHelper.instance;
    var query = await db.select(table, where: "PIN = ?", whereArgs: [pin]);
    return Transaction.fromListMap(query);
  }

  static Future<int> add(int pin, int islem) async {
    Transaction transaction = Transaction();
    DateTime now = new DateTime.now();
    transaction.date = DateFormat("dd.MM.yyyy HH:mm").format(now);
    transaction.pin = pin;
    transaction.islem = islem;
    var db = DbHelper.instance;
    return db.insert(table, transaction.toMap());
  }

  static Future<int> update(Transaction transaction) async {
    var db = DbHelper.instance;
    return db.update(table, transaction.id, transaction.toMap());
  }

  static Future<int> delete(int id) async {
    var db = DbHelper.instance;
    return db.delete(table, id);
  }

  static Future<int> count() {
    var db = DbHelper.instance;
    return db.count(table);
  }

  static Future<bool> uploadData() async {
    var deviceId = await DeviceInfo.getId();
    var server = await SharedPref.getString("serverUrl");
    var url = "$server/iclock/androidhar.aspx?SN=$deviceId";
    var list = await getAll();
    if (list != null && list.length > 0) {
      var response =
          await http.post(Uri.parse(url), body: Transaction.listToString(list));
      if (response.statusCode == 200 && response.body == "sonuc") {
        for (int i = 0; i < list.length; i++) {
          delete(list[i].id);
        }
        ToastMessage.show("Veriler Gönderildi");
        return true;
      }
    }
    return false;
  }
}
