import 'package:flutter/material.dart';

class CameraFooter extends StatelessWidget {
  const CameraFooter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, left: 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: FittedBox(
                  child: Icon(
                Icons.speaker_phone_rounded,
                color: Colors.white,
              ))),
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                "Yüzünüzü taratın\n ya da kartınızı okutun",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
    );
  }
}
