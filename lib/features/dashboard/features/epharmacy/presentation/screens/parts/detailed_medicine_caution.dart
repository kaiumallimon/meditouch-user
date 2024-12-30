import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

Widget detailedMedicineCautionDetails(
    Map<String, dynamic> details, ColorScheme theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: details.entries.map((entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.key,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 3),
          Html(
            data: entry.value.toString(),
            style: {
              'body': Style(
                fontSize: FontSize(14),
                textAlign: TextAlign.justify,
                color: theme.onSurface.withOpacity(.8),
              ),
            },
          ),
          const SizedBox(height: 20),
        ],
      );
    }).toList(),
  );
}