import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void changeSystemColor(bool darkTheme) {
  SystemChrome.setSystemUIOverlayStyle(!darkTheme
      ? SystemUiOverlayStyle(
          statusBarColor: Color.alphaBlend(
            const Color(0xFF470DC2).withOpacity(0.05), // Tint effect
            Colors.white,
          ),
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Color.alphaBlend(
            const Color(0xFF470DC2).withOpacity(0.05), // Tint effect
            Colors.white,
          ),
          systemNavigationBarIconBrightness: Brightness.dark,
        )
      : SystemUiOverlayStyle(
          statusBarColor: Color.alphaBlend(
            CupertinoColors.activeBlue.withOpacity(0.05), // Tint effect
            const Color(0xFF141414),
          ),
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color.alphaBlend(
            CupertinoColors.activeBlue.withOpacity(0.05), // Tint effect
            const Color(0xFF141414),
          ),
          systemNavigationBarIconBrightness: Brightness.light,
        ));
}
