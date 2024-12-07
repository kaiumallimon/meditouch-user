import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/navigation/logics/navigation_cubit.dart';
import 'package:r_icon_pro/r_icon_pro.dart';

class CustomFloatingNavigationBar extends StatelessWidget {
  const CustomFloatingNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return NavigationBar(
          surfaceTintColor: Theme.of(context).colorScheme.primary,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedIndex: currentIndex,
          onDestinationSelected: (int index) {
            BlocProvider.of<NavigationCubit>(context).switchTo(index);
          },
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(RIcon.Home_),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(RIcon.Medical_Kit),
              label: 'EPharmacy',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border),
              label: 'Appointments',
            ),
            NavigationDestination(
              icon: Icon(RIcon.Chat_Round_),
              label: 'Messages',
            ),
          ],
        );
      },
    );
  }
}
