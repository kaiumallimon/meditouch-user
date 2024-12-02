import 'package:flutter/material.dart';

TextStyle? getTitleStyle(Color color){
  return TextStyle(
    color: color,
    fontSize: 18,
    fontWeight: FontWeight.bold
  );
}

TextStyle? getParagraphStyle(Color color){
  return TextStyle(
      color: color,
      fontSize: 14,
      fontWeight: FontWeight.normal
  );
}
