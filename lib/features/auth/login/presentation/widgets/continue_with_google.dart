import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomGoogleButton extends StatelessWidget {
  const CustomGoogleButton(
      {super.key,
      required this.size,
      required this.text,
      required this.onPressed,
      required this.bgColor,
      required this.fgColor,
      required this.isLoading});
  final Size size;
  final String text;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color fgColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(
              width: 2,
              color: bgColor
            ),
            elevation: 0
          ),
          child: isLoading
              ? CupertinoActivityIndicator(
                  radius: 12,
                  color: fgColor,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/google-32.png',height: 22,),
                    const SizedBox(width: 10,),
                    Text(
                      text,
                      style: TextStyle(
                          color: fgColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
    );
  }
}
