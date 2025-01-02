import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      fontFamily: "SF-Pro-Text",
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF470DC2),
          primaryContainer: const Color.fromARGB(30, 70, 13, 194),
          onPrimaryContainer: Colors.black,
          onPrimary: Colors.white,
          secondary: CupertinoColors.activeOrange,
          onSecondary: Colors.white,
          error: Colors.red,
          surfaceContainer: Color.alphaBlend(
            const Color(0xFF470DC2).withOpacity(0.05), // Tint effect
            Colors.white,
          ),
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black));

  ThemeData getDarkTheme() => ThemeData(
      fontFamily: "SF-Pro-Text",
      useMaterial3: true,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: CupertinoColors.activeBlue,
          primaryContainer: const Color.fromARGB(30, 0, 123, 255),
          onPrimaryContainer: Colors.white,
          onPrimary: Colors.white,
          secondary: CupertinoColors.activeOrange,
          onSecondary: Colors.white,
          error: Colors.red,
          surfaceContainer: Color.alphaBlend(
            CupertinoColors.activeBlue.withOpacity(0.05), // Tint effect
            const Color(0xFF141414),
          ),
          onError: Colors.white,
          surface: const Color(0xFF141414),
          onSurface: Colors.white));
}
