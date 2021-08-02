import 'dart:async';

import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:terminal_app/pages/home.dart';
import 'package:terminal_app/pages/auth_login.dart';
import 'package:terminal_app/pages/temp_login.dart';
import 'package:terminal_app/pages/user_detail.dart';
import 'package:terminal_app/pages/settings.dart';
import 'package:terminal_app/pages/user_list.dart';
import 'package:terminal_app/services/device/toast_service.dart';
import 'package:terminal_app/services/web/user_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static _MyAppState state;
  @override
  _MyAppState createState() {
    state = _MyAppState();
    return state;
  }
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  CameraDescription cameraDescription;
  bool isConnected;
  @override
  void initState() {
    super.initState();
    getDeviceCamera();
    connectivityChanged();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        "/home": (context) => Home(),
        "/temp_login": (context) => TempLogin(),
        "/auth_login": (context) => AuthLogin(),
        "/settings": (context) => Settings(),
        "/user_detail": (context) => UserDetail(),
        "/user_list": (context) => UserList(),
      },
    );
  }

  getDeviceCamera() async {
    List<CameraDescription> cameras = await availableCameras();

    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );
  }

  connectivityChanged() {
    Timer timer;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        ToastService.show("İnternet bağlantısı yok");
        setState(() {
          isConnected = false;
        });
        if (timer != null && timer.isActive) {
          timer.cancel();
        }
      } else {
        ToastService.show("İnternet bağlantısı kuruldu");
        setState(() {
          isConnected = true;
        });
        UserService.downloadData();
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          UserService.downloadData();
        });
      }
    });
  }
}
