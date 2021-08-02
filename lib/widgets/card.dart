import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final color;
  final child;
  const CustomCard({Key key, this.color, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 15,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: child);
  }
}
