import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/themes/theme.dart';
import 'package:meditouch/features/auth/login/data/repository/login_repository.dart';
import 'package:meditouch/features/auth/login/logic/login_bloc.dart';
import 'package:meditouch/features/auth/login/login.dart';
import 'package:meditouch/features/auth/register/logic/date_cubit.dart';
import 'package:meditouch/features/auth/register/logic/gender_cubit.dart';
import 'package:meditouch/features/auth/register/logic/image_cubit.dart';
import 'package:meditouch/features/auth/register/logic/register_bloc.dart';
import 'package:meditouch/features/auth/register/presentation/screens/register_screen.dart';
import 'package:meditouch/features/dashboard/features/account/presentation/screens/theme_screen.dart';
import 'package:meditouch/features/dashboard/features/home/logics/home_bloc.dart';
import 'package:meditouch/features/dashboard/features/profile/profile.dart';
import 'package:meditouch/features/dashboard/navigation/logics/navigation_cubit.dart';
import 'package:meditouch/features/dashboard/wrapper/presentation/screens/dashboard_screen.dart';
import 'package:meditouch/features/startup/splash/logics/splash_bloc.dart';
import 'package:meditouch/features/startup/splash/splash.dart';
import 'package:meditouch/features/startup/welcome/logics/welcome_cubit.dart';
import 'package:meditouch/features/startup/welcome/welcome.dart';

import '../common/repository/hive_repository.dart';
import '../features/dashboard/features/account/logics/account_bloc.dart';
import '../features/dashboard/features/account/logics/account_events.dart';
import '../features/dashboard/features/account/logics/theme_cubit.dart';
import '../features/dashboard/features/epharmacy/logics/epharmacy_bloc.dart';
import '../features/dashboard/features/home/logics/home_event.dart';
import '../features/dashboard/features/profile/data/repository/profile_repository.dart';
import '../features/dashboard/features/profile/logics/profile_bloc.dart';

class MediTouchApp extends StatelessWidget {
  const MediTouchApp({super.key, required this.themeCubit});

  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    // initialize the blocs using multiblocprovider
    return MultiBlocProvider(
      providers: [
        // splash bloc
        BlocProvider<SplashBloc>(create: (_) => SplashBloc()),
        // welcome cubit
        BlocProvider<WelcomeCubit>(create: (_) => WelcomeCubit()),
        // register cubits
        BlocProvider<DateCubit>(create: (_) => DateCubit()),
        // gender cubit
        BlocProvider<GenderCubit>(create: (_) => GenderCubit()),
        // imagepicker cubit
        BlocProvider<ImagePickerCubit>(create: (_) => ImagePickerCubit()),
        // register bloc
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(),
        ),

        // login bloc
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(loginRepository: LoginRepository()),
        ),
        // navigation cubit
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),

        // home bloc
        BlocProvider<HomeBloc>(
            create: (_) =>
                HomeBloc(HiveRepository())..add(HomeRefreshRequested())),

        // account bloc
        BlocProvider<AccountBloc>(
            create: (_) => AccountBloc(hiveRepository: HiveRepository())
              ..add(const AccountRefreshRequested())),

        // theme cubit
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),

        // profile bloc
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            profileRepository: ProfileRepository(),
          ),
        ),

        // ephearmacy bloc
        BlocProvider<EpharmacyBloc>(
          create: (_) => EpharmacyBloc(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, darkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: darkMode ? AppTheme().getDarkTheme() : AppTheme().getTheme(),
            // define the routes
            initialRoute: "/",
            routes: {
              "/": (context) => const SplashScreen(),
              "/welcome": (context) => const WelcomeScreen(),
              "/login": (context) => LoginScreen(),
              "/register": (context) => const RegisterScreen(),
              "/dashboard": (context) => DashboardScreen(),
              "/profile": (context) => ProfileScreen(),
              "/theme": (context) => const ThemeScreen(),
            },
          );
        },
      ),
    );
  }
}
