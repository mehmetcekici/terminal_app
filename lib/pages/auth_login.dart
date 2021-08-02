import 'package:flutter/material.dart';
import 'package:terminal_app/services/device/nfc_service.dart';
import 'package:terminal_app/utils/extensions.dart';
import 'package:terminal_app/services/web/user_service.dart';
import 'package:terminal_app/utils/convert.dart';
import 'package:terminal_app/services/device/toast_service.dart';
import 'package:terminal_app/widgets/app_bar.dart';
import 'package:terminal_app/widgets/nfc_anim.dart';
import '../main.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({Key key}) : super(key: key);
  @override
  _AuthLoginState createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
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
            _alternativeLoginButton,
          ],
        ));
  }

  get _alternativeLoginButton {
    return Positioned(
      bottom: context.height / 15,
      child: TextButton(
        onPressed: () {
          NfcService.stop();
          Navigator.pushNamed(context, "/temp_login");
        },
        child: Text(
          "Kullanıcı adı ve Şifre ile giriş yap",
          style: TextStyle(
            fontSize: context.theme.headline6.fontSize,
          ),
        ),
      ),
    );
  }

  get _infoText {
    return Positioned(
      bottom: context.height / 5,
      child: Text(
        "Kartınızı okutunuz",
        textAlign: TextAlign.center,
        style: context.theme.headline4,
      ),
    );
  }

  get _animation {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.height / 5,
      ),
      child: CustomNfcAnim(
        controller: _animController,
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
      if (user != null && user.admin == 0) {
        NfcService.stop();
        Navigator.pushReplacementNamed(
          context,
          "/settings",
        );
      } else {
        ToastService.show(
          "Yetkili kullanıcı bulunamadı",
        );
      }
    }
  }
}
