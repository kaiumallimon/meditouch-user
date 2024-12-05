import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // retain statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // get theme
    final colorScheme = Theme.of(context).colorScheme;

    // set status bar and nav themes
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colorScheme.surface,
      statusBarIconBrightness: colorScheme.brightness,
      systemNavigationBarColor: colorScheme.surface,
      systemNavigationBarIconBrightness: colorScheme.brightness
    ));


    return Scaffold(
      body: SafeArea(child: Center(
        child: Text('Dashboard'),
      )),
    );
  }
}
