import 'package:flutter/material.dart';
import 'package:meditouch/common/widgets/custom_tinted_iconbutton.dart';

Widget buildGeminiMedicineScan(BuildContext context, Function onPressed) {
  return CustomTintedIconButton(
      child: Image.asset(
        'assets/icons/ai.png',
        width: 20,
        height: 20,
        fit: BoxFit.contain,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () => onPressed());
}
