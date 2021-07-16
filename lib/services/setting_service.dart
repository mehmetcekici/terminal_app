import 'package:terminal_app/utils/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:terminal_app/utils/shared_pref.dart';

class SettingService {
  static Future<int> checkLicence() async {
    var deviceId = await DeviceInfo.getId();
    var url =
        "http://www.pdksgold.com/iclock/andoridget.aspx?SN=$deviceId&lisans=1";
    var response = await http.get(Uri.parse(url));
    return int.parse(response.body);
  }

  static getServerUrl() async {
    var result = await SharedPref.getString("serverUrl");
    return result ?? "";
  }
}
