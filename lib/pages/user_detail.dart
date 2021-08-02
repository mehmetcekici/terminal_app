import 'dart:async';

import 'package:flutter/material.dart';
import 'package:terminal_app/entities/transaction.dart';
import 'package:terminal_app/entities/user.dart';
import 'package:terminal_app/pages/in_out.dart';
import 'package:terminal_app/services/web/transaction_service.dart';
import 'package:terminal_app/services/web/user_service.dart';
import 'package:terminal_app/services/device/toast_service.dart';
import 'package:terminal_app/widgets/transaction_list.dart';

class UserDetail extends StatefulWidget {
  final id;
  final isInput;
  UserDetail({Key key, this.id, this.isInput}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  User user;
  List<Transaction> transactions = <Transaction>[];
  bool isLoad = false;
  List<Color> colors;
  Color color;

  @override
  void initState() {
    super.initState();
    UserService.getById(widget.id).then((value) {
      if (value != null) {
        setState(() {
          user = value;
        });
        TransactionService.add(value.pin, widget.isInput ? 11 : 10)
            .then((value) {
          if (value > 0) {
            setState(() {
              isLoad = true;
              if (!widget.isInput) color = Colors.red;
            });
            TransactionService.getByPin(user.pin).then((value) {
              setState(() {
                transactions = value;
                transactions.sort((a, b) => b.id.compareTo(a.id));
              });
            });
          } else {
            ToastService.show("İşlem başarısız");
          }
        });
      }
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (isLoad && timer.tick >= 3) {
        timer.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => InOut(isInput: widget.isInput)));
      }
    });
    setState(() {
      colors = widget.isInput
          ? <Color>[
              Colors.green[400],
              Colors.green[600],
            ]
          : <Color>[
              Colors.red[400],
              Colors.red[600],
            ];
      color = widget.isInput ? Colors.green : Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors)),
          child: Container(
            width: double.infinity,
            height: 300,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: user != null
                          ? Icon(Icons.check, size: 80.0, color: color)
                          : Icon(
                              Icons.close_rounded,
                              size: 80.0,
                              color: Colors.red,
                            ),
                    ),
                  ),
                  SizedBox(height: 50),
                  user != null
                      ? Text(
                          user.kisi,
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                        )
                      : Text(""),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: TransactionList(
            transactions: transactions,
          ),
        ),
      ],
    ));
  }
}
