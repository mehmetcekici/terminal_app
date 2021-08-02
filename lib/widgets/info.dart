import 'package:flutter/material.dart';
import 'package:terminal_app/utils/extensions.dart';

class CustomInfo extends StatelessWidget {
  final bool cam;
  final bool nfc;
  const CustomInfo({
    Key key,
    this.cam = false,
    this.nfc = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle font = context.theme.subtitle1;
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(right: context.width / 2.5),
        child: Column(
          children: [
            infoItem(Icons.tag_faces, "Yüz Tanıma :", cam, font),
            infoItem(Icons.nfc, "NFC :", nfc, font)
          ],
        ),
      ),
      height: context.height / 5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
    );
  }

  infoItem(icon, text, ctrl, font) {
    return Row(
      children: [
        Expanded(flex: 1, child: Icon(icon, size: font.fontSize)),
        Expanded(flex: 2, child: Text(text)),
        Expanded(
            flex: 2,
            child: ctrl
                ? Text("Kullanılabilir",
                    style: font.apply(color: Colors.green[300]))
                : Text("Kullanılamıyor",
                    style: font.apply(color: Colors.red[300]))),
      ],
    );
  }
}
