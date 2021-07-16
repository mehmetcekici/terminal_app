import 'package:flutter/material.dart';

class CameraHeader extends StatelessWidget {
  final isInput;
  const CameraHeader({Key key, this.isInput}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 50),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          (isInput ? "GİRİŞ" : "ÇIKIŞ") + " TERMİNALİ",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
    );
  }
}
