// Greeting widget
  import 'package:flutter/material.dart';

Widget buildGreeting(ColorScheme theme, String name) {
    return Text(
      "Hi, $name",
      style: TextStyle(fontSize: 18, color: theme.onSurface, height: 1),
    );
  }