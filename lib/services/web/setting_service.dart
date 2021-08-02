import 'package:terminal_app/services/device/device_info_service.dart';
import 'package:http/http.dart' as http;
import 'package:terminal_app/services/device/shared_pref_service.dart';

class SettingService {
  static Future<int> checkLicence() async {
    var deviceId = await DeviceInfoService.getId();
    var url =
        "http://www.pdksgold.com/iclock/andoridget.aspx?SN=$deviceId&lisans=1";
    var response = await http.get(Uri.parse(url));
    return int.parse(response.body);
  }

  static getServerUrl() async {
    var result = await SharedPrefService.getString("serverUrl");
    return result ?? "";
  }
}
