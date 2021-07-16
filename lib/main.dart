import 'dart:async';

import 'package:flutter/material.dart';

import 'package:terminal_app/pages/home.dart';
import 'package:terminal_app/pages/login2.dart';
import 'package:terminal_app/pages/user_detail.dart';
import 'package:terminal_app/pages/nfc_scan.dart';
import 'package:terminal_app/pages/settings.dart';
import 'package:terminal_app/pages/login.dart';
import 'package:terminal_app/pages/user_list.dart';
import 'package:terminal_app/services/user_service.dart';

void main() {
  runApp(MyApp());
  UserService.downloadData();
  Timer.periodic(Duration(seconds: 1), (timer) {
    UserService.downloadData();
  });
}

class MyApp extends StatefulWidget {
  static _MyAppState myAppState;
  @override
  _MyAppState createState() {
    myAppState = _MyAppState();
    return myAppState;
  }
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        "/home": (context) => Home(),
        "/login": (context) => Login(),
        "/login2": (context) => Login2(),
        "/settings": (context) => Settings(),
        "/nfc_scan": (context) => NfcScan(),
        "/signup": (context) => NfcScan(),
        "/user_detail": (context) => UserDetail(),
        "/user_list": (context) => UserList(),
      },
    );
  }
}
