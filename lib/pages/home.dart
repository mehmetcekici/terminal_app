import 'package:flutter/material.dart';
import 'package:terminal_app/pages/register_login.dart';
import 'package:terminal_app/services/web/user_service.dart';
import 'package:terminal_app/services/device/shared_pref_service.dart';
import 'package:terminal_app/widgets/app_bar.dart';
import 'package:terminal_app/widgets/button.dart';
import 'package:terminal_app/widgets/grid_view.dart';

import 'in_out.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "TERMİNAL",
      ).build(context),
      body: CustomGrid(
        items: [
          inputButton,
          outputButton,
          registerButton,
          settingsButton,
        ],
      ),
    );
  }

  get inputButton {
    return CustomButton(
      iconData: Icons.arrow_back,
      iconDirection: TextDirection.rtl,
      text: "GİRİŞ TERMİNALİ",
      backgroundColor: Colors.green[700],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => InOut(isInput: true),
          ),
        );
      },
    );
  }

  get outputButton {
    return CustomButton(
      iconData: Icons.arrow_back,
      text: "ÇIKIŞ TERMİNALİ",
      backgroundColor: Colors.red[900],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => InOut(isInput: false),
          ),
        );
      },
    );
  }

  get registerButton {
    return CustomButton(
      iconData: Icons.tag_faces_rounded,
      text: "YÜZ VERİSİ EKLE",
      backgroundColor: Colors.blue,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => RegisterLogin(),
          ),
        );
      },
    );
  }

  get settingsButton {
    return CustomButton(
      iconData: Icons.settings,
      text: "AYARLAR",
      backgroundColor: Colors.grey[600],
      onTap: () async {
        var server = await SharedPrefService.getString("serverUrl");
        var adminCount = await UserService.count(
          where: "ADMIN = ?",
          whereArgs: [0],
        );
        if (server != null && server.isNotEmpty && adminCount > 0) {
          Navigator.pushNamed(context, "/auth_login");
        } else {
          Navigator.pushNamed(context, "/temp_login");
        }
      },
    );
  }
}
