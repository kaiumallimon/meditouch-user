import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton(
      {super.key,
        required this.size,
        required this.color,
        required this.textColor,
        required this.text,
        required this.hasBorder,
        required this.onPressed});

  final Size size;
  final Color color;
  final Color textColor;
  final String text;
  final bool hasBorder;
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
              elevation: 0,
            side: BorderSide(
              color: hasBorder? textColor.withOpacity(.3):Colors.transparent,
              width: 2
            )
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor),
          )),
    );
  }
}
