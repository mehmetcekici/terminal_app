import 'dart:async';

import 'package:flutter/material.dart';
import 'package:terminal_app/services/user_service.dart';
import 'package:terminal_app/utils/convert.dart';
import 'package:terminal_app/utils/shared_pref.dart';
import 'package:terminal_app/utils/toast_message.dart';
import 'package:terminal_app/widgets/nfc_anim.dart';
import 'package:nfc_io/nfc_io.dart';
import '../main.dart';

class Login2 extends StatefulWidget {
  Login2({Key key}) : super(key: key);

  @override
  _Login2State createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  AnimationController _controller;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = NfcIo.startReading.listen((data) {
      var cardNo = Convert.hextoDecimal(data.id);
      if (cardNo != null && cardNo.isNotEmpty) {
        UserService.getByCardNo(cardNo).then((value) {
          if (value != null && value.admin == 0) {
            SharedPref.add("cardNo", cardNo);
            close();
            Navigator.pushReplacementNamed(context, "/settings");
          } else {
            ToastMessage.show("Yetkili kullanıcı bulunamadı");
          }
        });
      }
    });
    _controller = AnimationController(
      vsync: MyApp.myAppState,
      lowerBound: 0.5,
      duration: Duration(seconds: 5),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              close();
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Giriş",
              style: TextStyle(fontSize: 25),
            ),
          ),
        ),
        body: NfcAnim.animation(_controller,
            "Ayarlara erişebilmek için yetkili kartınızı okutunuz", null));
  }

  close() async {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
      await NfcIo.stopReading;
    }
  }
}
