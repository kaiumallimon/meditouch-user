// custom app bar for orders screen
import 'package:flutter/material.dart';

AppBar ordersAppBar(BuildContext context, ColorScheme theme) {
  return AppBar(
    backgroundColor: theme.surfaceContainer,
    toolbarHeight: 70,
    elevation: 0,
    surfaceTintColor: theme.surfaceContainer,
    title: Text(
      'Orders',
      style: TextStyle(color: theme.onSurface),
    ),
    // leading: IconButton(
    //   icon: Icon(
    //     Icons.arrow_back_ios,
    //     color: theme.onSurface,
    //   ),
    //   onPressed: () {
    //     Navigator.pop(context);
    //   },
    // ),
  );
}
