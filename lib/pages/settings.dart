import 'package:flutter/material.dart';
import 'package:terminal_app/services/transaction_service.dart';
import 'package:terminal_app/services/user_service.dart';
import 'package:terminal_app/utils/device_info.dart';
import 'package:terminal_app/utils/shared_pref.dart';
import 'package:terminal_app/widgets/my_text_field.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController controller = TextEditingController();
  int userCount, transactionCount;
  String deviceId;
  @override
  void initState() {
    super.initState();

    DeviceInfo.getId().then((id) {
      this.setState(() {
        deviceId = id;
      });
    });

    SharedPref.getString("serverUrl").then((value) {
      setState(() {
        controller.text = value;
      });
    });

    UserService.count().then((value) {
      setState(() {
        userCount = value;
      });
    });

    TransactionService.count().then((value) {
      setState(() {
        transactionCount = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Ayarlar"),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.perm_device_info_rounded),
              title: Text("Teminal Kimliği"),
              trailing: Text(deviceId ?? "Bilinmiyor"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.cloud_done_rounded),
              title: MyTextField(
                  labelText: "server Url",
                  controller: controller,
                  padding: 0.0),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text("Terminaldeki Kişiler"),
              subtitle: Text("$userCount Kişi"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.pushNamed(context, "/user_list");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.sync_alt_rounded),
              title: Text("Gönderilmemiş Hareketler"),
              subtitle: Text("$transactionCount Hareket"),
              //trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                //Navigator.pushNamed(context, "/transactions");
              },
            ),
            Divider(),
            ButtonTheme(
              height: MediaQuery.of(context).size.height / 10,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                // ignore: deprecated_member_use
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  label: Text(
                    "SENKRONİZE ET",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  icon: Icon(
                    Icons.sync_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.green,
                  color: Colors.blue,
                  onPressed: () => click(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  click() {
    if (controller.text.isNotEmpty) {
      var url = controller.text;
      if (!url.startsWith("http")) url = "http://" + url;
      SharedPref.add("serverUrl", url).then((value) {
        if (value) {
          UserService.downloadData().then((value) {
            if (value) {
              UserService.count().then((value) {
                userCount = value;
              });
            }
          });
          TransactionService.uploadData().then((value) {
            if (value) {
              TransactionService.count().then((value) {
                setState(() {
                  transactionCount = value;
                });
              });
            }
          });
        }
      });
    }
  }
}
