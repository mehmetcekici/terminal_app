import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final type;
  final labelText;
  final onChanged;
  final controller;
  final padding;
  const MyTextField(
      {Key key,
      this.type,
      this.labelText,
      this.onChanged,
      this.controller,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 30),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.none,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            // hintText: 'Enter your product title',
            labelStyle: TextStyle(color: Colors.blueGrey),
            labelText: labelText),
        onChanged: (String value) {},
      ),
    );
  }
}
