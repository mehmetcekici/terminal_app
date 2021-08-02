import 'package:flutter/material.dart';
import 'package:terminal_app/pages/face_register.dart';
import 'package:terminal_app/services/device/nfc_service.dart';
import 'package:terminal_app/services/device/toast_service.dart';
import 'package:terminal_app/services/web/user_service.dart';
import 'package:terminal_app/utils/convert.dart';
import 'package:terminal_app/widgets/app_bar.dart';
import 'package:terminal_app/utils/extensions.dart';
import 'package:terminal_app/widgets/nfc_anim.dart';

import '../main.dart';

class RegisterLogin extends StatefulWidget {
  RegisterLogin({Key key}) : super(key: key);

  @override
  _RegisterLoginState createState() => _RegisterLoginState();
}

class _RegisterLoginState extends State<RegisterLogin> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    NfcService.start(onRead);
  }

  @override
  void dispose() {
    super.dispose();
    NfcService.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "YETKİLİ GİRİŞİ",
        ).build(context),
        body: Stack(
          alignment: Alignment.center,
          children: [
            _animation,
            _infoText,
            isAuth ? _selectFromList : SizedBox(),
          ],
        ));
  }

  get _infoText {
    return Positioned(
      bottom: context.height / 5,
      child: Text(
        isAuth
            ? "Kayıt yapılacak kullanıcının\n kartını okutunuz"
            : "Yetkili Kartınızı okutunuz",
        textAlign: TextAlign.center,
        style: context.theme.headline4.apply(color: Colors.white),
        overflow: TextOverflow.fade,
      ),
    );
  }

  get _animation {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.height / 5,
      ),
      child: CustomNfcAnim(
        color: isAuth ? Colors.green : Colors.blue,
        controller: _animController,
      ),
    );
  }

  get _selectFromList {
    return Positioned(
      bottom: context.height / 15,
      child: TextButton(
        onPressed: () {
          NfcService.stop();
          Navigator.pushNamed(context, "/user_list");
        },
        child: Text(
          "Listeden Seç",
          style: TextStyle(
            fontSize: context.theme.headline6.fontSize,
          ),
        ),
      ),
    );
  }

  get _animController {
    return AnimationController(
      vsync: MyApp.state,
      lowerBound: 0.5,
      duration: Duration(seconds: 5),
    )..repeat();
  }

  onRead(data) async {
    var cardNo = Convert.hextoDecimal(data.id);
    if (cardNo != null && cardNo.isNotEmpty) {
      var user = await UserService.getByCardNo(cardNo);
      if (!isAuth) {
        if (user != null && user.admin == 0) {
          setState(() {
            isAuth = true;
          });
        } else {
          ToastService.show(
            "Yetkili kullanıcı bulunamadı",
          );
        }
      } else {
        if (user != null) {
          NfcService.stop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => FaceRegister(id: user.id),
            ),
          );
        } else {
          ToastService.show(
            "Kullanıcı bulunamadı",
          );
        }
      }
    }
  }
}
