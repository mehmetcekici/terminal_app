import 'dart:async';
import 'package:nfc_io/nfc_io.dart';
import 'package:flutter/material.dart';
import 'package:terminal_app/main.dart';
import 'package:terminal_app/pages/user_detail.dart';
import 'package:terminal_app/services/user_service.dart';
import 'package:terminal_app/utils/convert.dart';
import 'package:terminal_app/utils/toast_message.dart';
import 'package:terminal_app/widgets/nfc_anim.dart';

class NfcScan extends StatefulWidget {
  final isInput;
  NfcScan({Key key, this.isInput}) : super(key: key);

  @override
  _NfcScanState createState() => _NfcScanState();
}

class _NfcScanState extends State<NfcScan> {
  AnimationController _controller;
  NfcData data;
  String cardNo;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = NfcIo.startReading.listen((data) {
      setState(() {
        this.data = data;
        cardNo = Convert.hextoDecimal(data.id);
        UserService.getByCardNo(cardNo).then((value) {
          if (value != null) {
            close();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UserDetail(
                          cardNo: cardNo,
                          isInput: widget.isInput,
                        )));
          } else {
            ToastMessage.show("Kullanıcı Bulunamadı");
          }
        });
      });
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              close();
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(widget.isInput ? "GİRİŞ" : "ÇIKIŞ"),
          ),
        ),
        body: widget.isInput
            ? NfcAnim.animation(
                _controller, "GİRİŞ YAPMAK İÇİN KARTINIZI OKUTUN", true)
            : NfcAnim.animation(
                _controller, "ÇIKIŞ YAPMAK İÇİN KARTINIZI OKUTUN", false));
  }

  close() async {
    if (_subscription != null) {
      _subscription.cancel();
      var result = await NfcIo.stopReading;
      setState(() {
        this.data = result;
      });
    }
  }
}
