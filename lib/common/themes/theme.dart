import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
      fontFamily: "SF-Pro-Text",
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF470DC2),
          onPrimary: Colors.white,
          secondary: CupertinoColors.activeOrange,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black));

  ThemeData getDarkTheme() => ThemeData(
      fontFamily: "SF-Pro-Text",
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: CupertinoColors.activeBlue,
          onPrimary: Colors.white,
          secondary: CupertinoColors.activeOrange,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Color(0xFF141414),
          onSurface: Colors.white));
}
