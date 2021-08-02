import 'package:flutter/material.dart';
import 'package:terminal_app/main.dart';
import 'package:terminal_app/services/web/transaction_service.dart';
import 'package:terminal_app/services/web/user_service.dart';
import 'package:terminal_app/services/device/device_info_service.dart';
import 'package:terminal_app/utils/extensions.dart';
import 'package:terminal_app/services/device/shared_pref_service.dart';
import 'package:terminal_app/services/device/toast_service.dart';
import 'package:terminal_app/widgets/app_bar.dart';
import 'package:terminal_app/widgets/button.dart';
import 'package:terminal_app/widgets/circular_progress.dart';
import 'package:terminal_app/widgets/text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController controller = TextEditingController();
  int userCount, transactionCount;
  String deviceId;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "AYARLAR",
      ).build(context),
      body: loading
          ? CircularProgress()
          : Container(
              child: ListView(
                children: <Widget>[
                  _deviceInfo,
                  Divider(),
                  _serverInfo,
                  Divider(),
                  _userInfo,
                  Divider(),
                  _transactionsInfo,
                  Divider(),
                  _syncButton,
                ],
              ),
            ),
    );
  }

  get _deviceInfo {
    return ListTile(
      leading: Icon(Icons.perm_device_info_rounded),
      title: Text("Teminal Kimliği"),
      trailing: Text(deviceId ?? "Bilinmiyor"),
    );
  }

  get _serverInfo {
    return ListTile(
      leading: Icon(FontAwesomeIcons.globe),
      title: Text("Sunucu Adresi"),
      subtitle: CustomTextField(
        controller: controller,
        hintText: "www.domain.com",
        keyboardType: TextInputType.url,
      ),
    );
  }

  get _userInfo {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle),
      title: Text("Terminaldeki Kişiler"),
      subtitle: Text("$userCount Kişi"),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        Navigator.pushNamed(context, "/user_list");
      },
    );
  }

  get _transactionsInfo {
    return ListTile(
      leading: Icon(Icons.sync_alt_rounded),
      title: Text("Gönderilmemiş Hareketler"),
      subtitle: Text("$transactionCount Hareket"),
      //trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        //Navigator.pushNamed(context, "/transactions");
      },
    );
  }

  get _syncButton {
    return Padding(
      padding: EdgeInsets.only(
        left: context.width / 5,
        right: context.width / 5,
        top: context.height / 20,
      ),
      child: CustomButton(
        iconData: Icons.sync,
        text: "SENKRONİZE ET",
        onTap: () {
          if (MyApp.state.isConnected) {
            click();
          } else {
            ToastService.show("İnternet bağlantısı gerekli");
          }
        },
      ),
    );
  }

  click() async {
    if (controller.text.isNotEmpty) {
      setState(() {
        loading = true;
      });
      var url = controller.text;
      if (!url.startsWith("http")) url = "http://" + url;
      await SharedPrefService.add("serverUrl", url);
      await UserService.downloadData();
      await TransactionService.uploadData();
      getData();
    } else {
      ToastService.show("Sunucu adresi giriniz...");
    }
  }

  getData() async {
    var deviceid = await DeviceInfoService.getId();
    var serverurl = await SharedPrefService.getString("serverUrl");
    var usercount = await UserService.count();
    var transcount = await TransactionService.count();

    setState(() {
      deviceId = deviceid;
      controller.text = serverurl;
      userCount = usercount;
      transactionCount = transcount;
      loading = false;
    });
  }
}
