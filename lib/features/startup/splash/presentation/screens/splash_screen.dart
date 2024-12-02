import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/startup/splash/logics/splash_bloc.dart';
import 'package:meditouch/common/widgets/gradient_bg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // trigger to start the splash logic
    BlocProvider.of<SplashBloc>(context).add(SplashStartedEvent());

    // hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // build the ui
    return Scaffold(
      body: SafeArea(
          child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          // check the state
          if (state is SplashLoadedState) {
            Navigator.pushReplacementNamed(context, "/welcome");
          }
        },
        child: Stack(
          children: [
            // gradient background for the splash bg
            const GradientBackground(),

            // image in the center
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/logo2.png',
                scale: 2,
              ),
            )
          ],
        ),
      )),
    );
  }
}
