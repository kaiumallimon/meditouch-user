import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/startup/splash/logics/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SplashBloc()..add(SplashStartedEvent()),
        child: BlocListener(listener: (context, state) {
          if(state is SplashLoadedState){
            
          }
        }));
  }
}
