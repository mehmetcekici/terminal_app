import 'package:terminal_app/entities/user.dart';
import 'package:terminal_app/services/device/db_service.dart';
import 'package:http/http.dart' as http;
import 'package:terminal_app/services/device/device_info_service.dart';
import 'package:terminal_app/services/device/shared_pref_service.dart';

class UserService {
  static final table = "Users";
  static List<User> _users;

  static Future<bool> downloadData() async {
    if (_users == null) _users = <User>[];
    var deviceId = await DeviceInfoService.getId();
    var server = await SharedPrefService.getString("serverUrl");
    var url = "$server/iclock/andoridget.aspx?SN=$deviceId";
    http.Response response;
    if (server != null && server.isNotEmpty) {
      response = await http.get(Uri.parse(url));
    }
    if (response != null) {
      var list = User.fromJsonList(response.body);
      if (list != null && list.length > 0) {
        _users.addAll(list);
        if (list.length == 10) {
          downloadData();
        } else {
          print("Tüm veriler indirildi");
          for (int i = 0; i < _users.length; i++) {
            if (_users[i].islem.compareTo("EKLE") == 0) {
              var result = await getByPin(_users[i].pin);
              if (result == null) {
                add(_users[i]);
              } else {
                _users[i].id = result.id;
                update(_users[i]);
              }
            }
            if (_users[i].islem.compareTo("SIL") == 0) {
              delete(_users[i].id);
            }
          }
          _users = null;
          return true;
        }
      }
      return false;
    }
    return false;
  }

  /// User get all from local db
  static Future<List<User>> getAll(
      {String where, List<Object> whereArgs}) async {
    var db = DbService.instance;
    var result = await db.select(table, where: where, whereArgs: whereArgs);
    return User.fromSqfLiteList(result);
  }

  static Future<User> getById(int id) async {
    var db = DbService.instance;

    var result = await db.select(table, where: "ID = ?", whereArgs: [id]);
    return User.fromSqfLiteList(result).first;
  }

  static Future<User> getByPin(int pin) async {
    var db = DbService.instance;
    var query = await db.select(table, where: "PIN = ?", whereArgs: [pin]);
    var result = User.fromSqfLiteList(query);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  static Future<User> getByCardNo(String cardNo) async {
    var db = DbService.instance;
    var query =
        await db.select(table, where: "KARTDEC = ?", whereArgs: [cardNo]);
    var result = User.fromSqfLiteList(query);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  static Future<int> add(User user) async {
    var db = DbService.instance;
    return db.insert(table, user.toMapForSqfLite());
  }

  static Future<int> update(User user) async {
    var db = DbService.instance;
    return db.update(table, user.id, user.toMapForSqfLite());
  }

  static Future<int> delete(int id) async {
    var db = DbService.instance;
    return db.delete(table, id);
  }

  static Future<int> count({String where, List<Object> whereArgs}) {
    var db = DbService.instance;
    return db.count(table, where: where, whereArgs: whereArgs);
  }
}
