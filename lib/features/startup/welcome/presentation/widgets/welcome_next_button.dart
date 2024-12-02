import 'package:flutter/material.dart';

class WelcomeNextButton extends StatelessWidget {
  const WelcomeNextButton(
      {super.key,
      required this.size,
      required this.color,
      required this.textColor,
      required this.text,
      required this.onPressed});

  final Size size;
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            elevation: 2
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor),
          )),
    );
  }
}
