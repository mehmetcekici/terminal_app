import 'package:flutter/material.dart';
import 'package:terminal_app/utils/extensions.dart';
import 'package:terminal_app/services/web/setting_service.dart';
import 'package:terminal_app/widgets/app_bar.dart';
import 'package:terminal_app/widgets/button.dart';
import 'package:terminal_app/widgets/text_field.dart';

class TempLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TempLoginState();
  }
}

class _TempLoginState extends State<TempLogin> {
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
      appBar: CustomAppBar(title: "GEÇİCİ GİRİŞ").build(context),
      body: body,
    );
  }

  get body {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomTextField(
              hintText: "Kullanıcı Adı",
              prefixIcon: Icons.person,
              controller: nameController,
            ),
            SizedBox(height: 25),
            CustomTextField(
              controller: passController,
              isPassword: true,
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.18,
              ),
              child: CustomButton(
                backgroundColor: Colors.blue,
                text: "GİRİŞ",
                onTap: () {
                  if (ctrl) {
                    Navigator.pushReplacementNamed(context, "/settings");
                  }
                },
              ),
            ),
            SizedBox(height: 70),
            Text(
              "! Kullanıcı adı ve Şifre için sistem yöneticisine başurunuz.",
              style: context.theme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }

  get ctrl {
    var ctrlName = nameController.text == "admin";
    var now = DateTime.now();
    //var y = now.year.toString();
    //var d = now.day.toString();
    var h = now.hour.toString();
    var m = now.minute.toString();
    if (int.parse(h) < 10) h = "0" + h;
    if (int.parse(m) < 10) m = "0" + m;
    var ctrlPass = passController.text == h + m;
    return ctrlName && ctrlPass;
  }
}
