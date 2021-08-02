import 'package:flutter/material.dart';

class CustomNfcAnim extends StatelessWidget {
  final Color color;
  final controller;
  const CustomNfcAnim({Key key, @required this.controller, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedBuilder(
          animation:
              CurvedAnimation(parent: controller, curve: Curves.bounceInOut),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _buildContainer(150 * controller.value, controller.value),
                _buildContainer(200 * controller.value, controller.value),
                _buildContainer(250 * controller.value, controller.value),
                _buildContainer(300 * controller.value, controller.value),
                _buildContainer(350 * controller.value, controller.value),
                Align(
                    child: Icon(
                  Icons.speaker_phone_rounded,
                  size: 50,
                )),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildContainer(double radius, value) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color != null
            ? color.withOpacity(1 - value)
            : Colors.blue.withOpacity(1 - value),
      ),
    );
  }
}
