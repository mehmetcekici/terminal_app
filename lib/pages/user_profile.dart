import 'package:flutter/material.dart';
import 'package:terminal_app/entities/transaction.dart';
import 'package:terminal_app/entities/user.dart';
import 'package:terminal_app/pages/face_register.dart';
import 'package:terminal_app/services/web/transaction_service.dart';
import 'package:terminal_app/services/web/user_service.dart';
import 'package:terminal_app/widgets/transaction_list.dart';

class UserProfile extends StatefulWidget {
  final id;
  UserProfile({Key key, this.id}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User user;
  List<Transaction> transactions = <Transaction>[];
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    UserService.getById(widget.id).then((value) {
      if (value != null) {
        setState(() {
          user = value;
        });
        TransactionService.getByPin(user.pin).then((value) {
          setState(() {
            transactions = value;
            transactions.sort((a, b) => b.id.compareTo(a.id));
            isLoad = true;
          });
        });
      }
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
                  colors: [Colors.blue[400], Colors.blue[600]])),
          child: Container(
            width: double.infinity,
            height: 300,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
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
                            ? Icon(Icons.check, size: 80.0, color: Colors.white)
                            : Icon(
                                Icons.close_rounded,
                                size: 80.0,
                                color: Colors.red,
                              ),
                      ),
                    ),
                    SizedBox(height: 40),
                    user != null
                        ? Text(
                            user.kisi,
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          )
                        : Text(""),
                    SizedBox(height: 10),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.black,
                      child: user.face == null
                          ? Text("Yüz Ekle")
                          : Text("Yüzü Değiştir"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FaceRegister(id: user.id)));
                      },
                    ),
                  ],
                ),
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
