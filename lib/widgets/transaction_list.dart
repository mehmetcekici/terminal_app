import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final transactions;
  const TransactionList({Key key, this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          width: double.infinity,
          height: 30,
          color: Colors.blue,
          child: Text(
            "Önceki Hareketler",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: transactions[index].islem == 11
                      ? Icon(
                          Icons.arrow_back,
                          textDirection: TextDirection.rtl,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.arrow_back,
                          color: Colors.red,
                        ),
                  title: Text(
                    transactions[index].islem == 11 ? "GİRİŞ" : "ÇIKIŞ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  trailing: Text(
                    transactions[index].date,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
