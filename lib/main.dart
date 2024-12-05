import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/themes/theme.dart';
import 'package:meditouch/features/auth/login/data/repository/login_repository.dart';
import 'package:meditouch/features/auth/login/logic/login_bloc.dart';
import 'package:meditouch/features/auth/login/login.dart';
import 'package:meditouch/features/auth/register/logic/date_cubit.dart';
import 'package:meditouch/features/auth/register/logic/gender_cubit.dart';
import 'package:meditouch/features/auth/register/logic/image_cubit.dart';
import 'package:meditouch/features/auth/register/logic/register_bloc.dart';
import 'package:meditouch/features/auth/register/presentation/screens/register_screen.dart';
import 'package:meditouch/features/dashboard/wrapper/presentation/screens/dashboard_screen.dart';
import 'package:meditouch/features/startup/splash/logics/splash_bloc.dart';
import 'package:meditouch/features/startup/splash/splash.dart';
import 'package:meditouch/features/startup/welcome/logics/welcome_cubit.dart';
import 'package:meditouch/features/startup/welcome/welcome.dart';

void main() async {
  // initialize hive: local database
  await Hive.initFlutter();
  await HiveRepository().init();


  // load the .env file
  await dotenv.load(fileName: ".env");

  // run the app
  runApp(const MediTouchApp());
}

class MediTouchApp extends StatelessWidget {
  const MediTouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    // initialize the blocs using multiblocprovider
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (_) => SplashBloc()),
        BlocProvider<WelcomeCubit>(create: (_) => WelcomeCubit()),
        BlocProvider<DateCubit>(create: (_)=>DateCubit()),
        BlocProvider<GenderCubit>(create: (_)=>GenderCubit()),
        BlocProvider<ImagePickerCubit>(create: (_)=>ImagePickerCubit()),
        BlocProvider<RegisterBloc>(create: (_)=>RegisterBloc(),),
        BlocProvider<LoginBloc>(create: (_)=>LoginBloc(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        darkTheme: AppTheme().getDarkTheme(),
        // define the routes
        initialRoute: "/",
        routes: {
          "/": (context) => const SplashScreen(),
          "/welcome": (context) => WelcomeScreen(),
          "/login": (context) => LoginScreen(),
          "/register": (context) => RegisterScreen(),
          "/dashboard": (context)=> DashboardScreen()
        },
      ),
    );
  }
}
