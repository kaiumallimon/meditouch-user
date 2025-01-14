import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/utils/system_colors.dart';
import 'app/meditouch_app.dart';
import 'common/utils/welcome_util.dart';
import 'features/dashboard/features/account/logics/theme_cubit.dart';

void main() async {
  // ensure flutterBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp();

  // initialize hive: local database
  await Hive.initFlutter();
  var hiveRepository = HiveRepository();

  // initialize hive repository
  await hiveRepository.init();

  // get user info
  var userInfo = await hiveRepository.getUserInfo();

  bool isLoggedIn = userInfo != null &&
      userInfo.containsKey('id') &&
      (userInfo['id']?.toString().isNotEmpty ?? false);

  // load the .env file
  await dotenv.load(fileName: ".env");

  // theme
  final themeCubit = ThemeCubit();
  themeCubit.loadTheme();

  bool darktheme = themeCubit.isDarkTheme();

  changeSystemColor(darktheme);

  bool isWelcomeWatched = await getWelcomePageWatched();

  // run the app
  runApp(MediTouchApp(
    themeCubit: themeCubit,
    isLoggedIn: isLoggedIn,
    isWelcomeWatched: isWelcomeWatched,
  ));
}
