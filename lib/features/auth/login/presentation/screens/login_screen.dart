// file: login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // retain the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    // get theme
    final theme = Theme.of(context).colorScheme;
    
    // set status bar and nav bar colors:
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: theme.surface,
      statusBarIconBrightness: theme.brightness,
      systemNavigationBarColor: theme.surface,
      systemNavigationBarIconBrightness: theme.brightness
    ));
    return Scaffold(
      body: SafeArea(child: Column()),
    );
  }
}
