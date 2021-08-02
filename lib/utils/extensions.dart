import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension Sizes on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}

extension Themes on BuildContext {
  TextTheme get theme => Theme.of(this).textTheme;
}
