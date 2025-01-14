import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/account/presentation/widgets/custom_tile.dart';

import '../../logics/theme_cubit.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      // app bar
      appBar: AppBar(
        title: const Text('Theme'),
        backgroundColor: theme.surfaceContainer,
        toolbarHeight: 70,
      ),

      // body
      body: SafeArea(
        child: Padding(
          // padding
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // dark mode tile
              CustomTile(
                  onTap: () {
                    // toggle dark mode
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  padding: 10,
                  tileColor: theme.primaryContainer,
                  borderRadius: 15,
                  leading: Icon(Icons.dark_mode, color: theme.primary),
                  title: const Text('Dark Mode',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Enable dark mode',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),

                  // trailing switch button for dark mode toggle
                  trailing: CupertinoSwitch(
                      activeColor: theme.primary,

                      // get the current theme from the cubit
                      value: context.watch<ThemeCubit>().state,
                      onChanged: (value) {
                        context.read<ThemeCubit>().toggleTheme();
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
