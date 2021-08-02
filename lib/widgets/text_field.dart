import 'package:flutter/material.dart';
import 'package:terminal_app/utils/extensions.dart';

class CustomTextField extends StatefulWidget {
  final hintText;
  final controller;
  final prefixIcon;
  final suffixIcon;
  final isPassword;
  final keyboardType;
  final onChanged;
  final TextStyle textStyle;
  const CustomTextField({
    Key key,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.hintText,
    this.isPassword = false,
    this.keyboardType,
    this.onChanged,
    this.textStyle,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var iconData;
  var visible;

  @override
  void initState() {
    super.initState();
    iconData = Icons.visibility_off;
    visible = !widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !visible,
      controller: widget.controller,
      style: widget.textStyle?? context.theme.headline5,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: Colors.white,
      cursorHeight: widget.textStyle!=null?widget.textStyle.height:context.theme.headline5.fontSize,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        hintText: widget.hintText ?? "****",
        prefixIcon: widget.isPassword
            ? Icon(Icons.lock_open_outlined, color: Colors.white70)
            : widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon, color: Colors.white70),
        suffixIcon: widget.suffixIcon != null
            ? widget.suffixIcon
            : !widget.isPassword
                ? SizedBox()
                : IconButton(
                    icon: Icon(
                      iconData,
                      color: visible ? Colors.white70 : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        visible = !visible;
                        if (visible) {
                          iconData = Icons.visibility_outlined;
                        } else {
                          iconData = Icons.visibility_off_outlined;
                        }
                      });
                    },
                  ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
