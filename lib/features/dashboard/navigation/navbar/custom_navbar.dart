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
          selectedIndex: currentIndex,
          onDestinationSelected: (int index) {
            BlocProvider.of<NavigationCubit>(context).switchTo(index);
          },
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor:
              Theme.of(context).colorScheme.primary.withOpacity(.15),
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.medical_services_outlined),
              selectedIcon: Icon(
                Icons.medical_services,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: 'E-Pharmacy',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(
                Icons.bookmark,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: 'Appts',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              selectedIcon: Icon(
                Icons.chat,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: 'Inbox',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(
                Icons.account_circle,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: 'Account',
            ),
          ],
        );
      },
    );
  }
}
