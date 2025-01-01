import 'package:flutter/material.dart';

Widget buildCustomAppBar(BuildContext context, ColorScheme theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('E-Pharmacy',
          style: TextStyle(
              height: 1,
              color: theme.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Text('Powered by MedEasy',
          style:
              TextStyle(color: theme.onSurface.withOpacity(.5), fontSize: 12)),
    ],
  );
}
