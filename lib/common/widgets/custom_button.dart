import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.size,
      required this.text,
      required this.onPressed,
      required this.bgColor,
      this.textSize,
      required this.fgColor,
      required this.isLoading});
  final Size size;
  final String text;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color fgColor;
  final bool isLoading;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: isLoading
              ? CupertinoActivityIndicator(
                  radius: 12,
                  color: fgColor,
                )
              : Text(
                  text,
                  style: TextStyle(
                      color: fgColor,
                      fontWeight: FontWeight.bold,
                      fontSize: textSize ?? 14),
                )),
    );
  }
}
