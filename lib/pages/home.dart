import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
//import 'package:terminal_app/pages/nfc_scan.dart';
import 'package:terminal_app/pages/in_out.dart';
import 'package:terminal_app/services/user_service.dart';
import 'package:terminal_app/utils/face_service.dart';
import 'package:terminal_app/utils/shared_pref.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraDescription cameraDescription;

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  _startUp() async {
    await FaceService().loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        leadingWidth: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Terminal"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => click(),
                ),
              ],
            ),
          )
        ],
      ),
      body: Center(
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              button(true),
              SizedBox(height: 50),
              button(false),
              SizedBox(height: 50),
              geciciKayitButon(),
            ],
          ),
        ),
      ),
    );
  }

  geciciKayitButon() {
    // ignore: deprecated_member_use
    return RaisedButton(
      child: Text("KAYIT"),
      onPressed: () {
        Navigator.pushNamed(context, "/signup");
      },
    );
  }

  button(bool isInput) {
    // ignore: deprecated_member_use
    return RaisedButton.icon(
      onPressed: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NfcScan(isInput: isInput)));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => InOut(
              isInput: isInput,
            ),
          ),
        );
      },
      padding: EdgeInsets.only(right: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      label: Text(
        isInput ? "GİRİŞ" : "ÇIKIŞ",
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
      icon: Icon(
        Icons.arrow_back,
        textDirection: isInput ? TextDirection.rtl : TextDirection.ltr,
        size: 50,
        color: Colors.white,
      ),
      textColor: Colors.white,
      splashColor: Colors.red,
      color: isInput ? Colors.green : Colors.red,
    );
  }

  click() async {
    var server = await SharedPref.getString("serverUrl");
    var adminCount =
        await UserService.count(where: "ADMIN = ?", whereArgs: [0]);
    if (server != null && server.isNotEmpty && adminCount > 0) {
      Navigator.pushNamed(context, "/login2");
    } else {
      Navigator.pushNamed(context, "/login");
    }
  }
}
