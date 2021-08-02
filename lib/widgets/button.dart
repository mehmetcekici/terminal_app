import 'package:flutter/material.dart';
import 'package:terminal_app/utils/extensions.dart';
import 'package:terminal_app/widgets/card.dart';

class CustomButton extends StatelessWidget {
  final iconData;
  final iconDirection;
  final text;
  final backgroundColor;
  final iconColor;
  final textColor;
  final onTap;
  const CustomButton({
    Key key,
    this.iconData,
    this.iconDirection,
    this.text,
    this.backgroundColor,
    this.onTap,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double padding = context.theme.headline5.height ?? 25 / 2;
    return CustomCard(
      color: backgroundColor ?? Colors.black,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: Row(
            children: [
              iconData == null
                  ? SizedBox()
                  : Expanded(
                      flex: 4,
                      child: Icon(
                        iconData,
                        textDirection: iconDirection,
                        color: iconColor,
                      ),
                    ),
              iconData == null
                  ? SizedBox()
                  : Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
              Expanded(
                flex: 15,
                child: Text(
                  text,
                  style: context.theme.headline5.apply(color: textColor),
                  textAlign:
                      iconData == null ? TextAlign.center : TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
