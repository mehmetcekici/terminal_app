import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final title;
  final leading;
  final actions;
  const CustomAppBar({Key key, this.title, this.leading, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      elevation: 1,
      toolbarHeight: MediaQuery.of(context).size.height / 10,
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5.apply(color: Colors.white),
      ),
      actions: actions,
    );
  }
}
