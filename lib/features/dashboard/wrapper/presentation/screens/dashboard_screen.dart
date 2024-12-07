import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/appointments/appointments.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/epharmacy.dart';
import 'package:meditouch/features/dashboard/features/home/home.dart';
import 'package:meditouch/features/dashboard/features/messages/messages.dart';
import 'package:meditouch/features/dashboard/navigation/navbar/custom_navbar.dart';

import '../../../navigation/logics/navigation_cubit.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // retain status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // get theme
    final colorScheme = Theme.of(context).colorScheme;

    // set status bar and nav themes
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colorScheme.surface,
        statusBarIconBrightness: colorScheme.brightness,
        systemNavigationBarColor: Color.alphaBlend(
          colorScheme.primary.withOpacity(0.08), // Tint effect
          colorScheme.surface,
        ),
        systemNavigationBarIconBrightness: colorScheme.brightness));

    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<NavigationCubit, int>(
            builder: (context, state) => screens[state]),
        bottomNavigationBar: const CustomFloatingNavigationBar(),
      ),
    );
  }

  final List<Widget> screens = [
    HomeScreen(),
    EpharmacyScreen(),
    AppointmentScreen(),
    MessagesScreen()
  ];
}
