import 'package:flutter/material.dart';

class CustomGrid extends StatelessWidget {
  final List items;
  const CustomGrid({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 25),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3,
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.landscape ? 2 : 1,
      ),
      itemBuilder: (context, index) {
        return Container(padding: EdgeInsets.all(10), child: items[index]);
      },
    );
  }
}
