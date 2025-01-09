import 'package:flutter/material.dart';

import 'default_scan_body.dart';

GestureDetector medicineScanFailure(
      BuildContext context, ColorScheme theme, String error) {
    return GestureDetector(
      onTap: () => openModalSheet(context, theme),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(30),
            child: Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: theme.error,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            error,
            style: TextStyle(color: theme.error),
          ),
        ],
      ),
    );
  }