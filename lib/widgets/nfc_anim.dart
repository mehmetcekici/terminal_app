import 'package:flutter/material.dart';

class NfcAnim {
  static Widget animation(
      AnimationController _controller, String info, bool isInput) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 200.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedBuilder(
                animation: CurvedAnimation(
                    parent: _controller, curve: Curves.bounceInOut),
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      _buildContainer(
                          150 * _controller.value, _controller.value, isInput),
                      _buildContainer(
                          200 * _controller.value, _controller.value, isInput),
                      _buildContainer(
                          250 * _controller.value, _controller.value, isInput),
                      _buildContainer(
                          300 * _controller.value, _controller.value, isInput),
                      _buildContainer(
                          350 * _controller.value, _controller.value, isInput),
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 250.0),
          child: Text(
            info,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
                wordSpacing: 3),
          ),
        ),
      ],
    );
  }

  static Widget _buildContainer(double radius, value, bool isInput) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isInput == null
            ? Colors.blue.withOpacity(1 - value)
            : isInput
                ? Colors.green.withOpacity(1 - value)
                : Colors.red.withOpacity(1 - value),
      ),
    );
  }
}
