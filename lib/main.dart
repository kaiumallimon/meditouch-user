import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/themes/theme.dart';
import 'package:meditouch/features/startup/splash/logics/splash_bloc.dart';
import 'package:meditouch/features/startup/splash/splash.dart';

void main() {
  runApp(const MediTouchApp());
}

class MediTouchApp extends StatelessWidget {
  const MediTouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>SplashBloc())
      ],
      child: MaterialApp(
        theme: AppTheme().getTheme(),
        darkTheme: AppTheme().getDarkTheme(),
        initialRoute: "/",
        routes: {
          "/":(context)=> const SplashScreen()
        },
      ),
    );
  }
}
