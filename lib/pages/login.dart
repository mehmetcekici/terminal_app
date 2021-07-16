import 'package:flutter/material.dart';
import 'package:terminal_app/services/setting_service.dart';
import 'package:terminal_app/services/user_service.dart';
import 'package:terminal_app/utils/convert.dart';
import 'package:terminal_app/utils/shared_pref.dart';
import 'package:terminal_app/utils/toast_message.dart';
import 'package:terminal_app/widgets/my_text_field.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  void initState() {
    super.initState();
    SettingService.checkLicence().then((value) {
      if (value != 0) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "Giriş",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 150.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MyTextField(
                    labelText: "kullanıcı adı", controller: nameController),
                SizedBox(height: 25),
                MyTextField(labelText: "parola", controller: passController),
                SizedBox(height: 50),
                // ignore: deprecated_member_use
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text(
                    'Giriş',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    var ctrlName = nameController.text == "admin";
                    var now = DateTime.now();
                    //var y = now.year.toString();
                    //var d = now.day.toString();
                    var h = now.hour.toString();
                    var m = now.minute.toString();
                    if (int.parse(m) < 10) m = "0" + m;
                    var ctrlPass = passController.text == h + m;
                    if (ctrlName && ctrlPass) {
                      Navigator.pushReplacementNamed(context, "/settings");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  startLogin(String id) {
    var cardNo = Convert.hextoDecimal(id);
    if (cardNo != null && cardNo.isNotEmpty) {
      UserService.getByCardNo(cardNo).then((value) {
        if (value != null && value.admin == 0) {
          SharedPref.add("cardNo", cardNo);
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          ToastMessage.show("Yetkili kullanıcı bulunamadı");
        }
      });
    }
  }
}
