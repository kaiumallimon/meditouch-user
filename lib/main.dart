import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/repository/detailed_doctor_repository.dart';
import 'package:meditouch/features/dashboard/features/doctors/logics/detailed_doctor_controller.dart';

import 'app/meditouch_app.dart';
import 'features/dashboard/features/account/logics/theme_cubit.dart';

void main() async {
  // ensure flutterBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp();

  // initialize hive: local database
  await Hive.initFlutter();
  await HiveRepository().init();

  // load the .env file
  await dotenv.load(fileName: ".env");

  // theme
  final themeCubit = ThemeCubit();
  themeCubit.loadTheme();

  

  // run the app
  runApp(MediTouchApp(
    themeCubit: themeCubit,
  ));
}
