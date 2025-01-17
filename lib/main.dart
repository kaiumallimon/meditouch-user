import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/utils/system_colors.dart';
import 'app/meditouch_app.dart';
import 'common/permissions/permissions_manager.dart';
import 'common/push_notification/notification_service.dart';
import 'common/utils/welcome_util.dart';
import 'features/dashboard/features/account/logics/theme_cubit.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'features/dashboard/features/medication/data/repository/medication_db_helper.dart';
import 'features/dashboard/features/medication/data/repository/medication_notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  ///
  /// Ensure that the Flutter app is initialized before running the app
  ///
  WidgetsFlutterBinding.ensureInitialized();

  ///
  /// Initialize Firebase
  ///
  await Firebase.initializeApp();

  ///
  /// Initialize Hive
  ///
  await Hive.initFlutter();

  ///
  /// Initialize Hive Repository
  ///
  var hiveRepository = HiveRepository();
  await hiveRepository.init();
  // Open a Hive box for storing messages
  await Hive.openBox('chatMessages');
  // await MedicationNotificationService.init();

  tz.initializeTimeZones();

  //initialize reminder database
  await MedicationDBHelper().database;

  ///
  /// Check if the user is logged in
  ///
  var userInfo = await hiveRepository.getUserInfo();

  bool isLoggedIn = userInfo != null &&
      userInfo.containsKey('id') &&
      (userInfo['id']?.toString().isNotEmpty ?? false);

  ///
  /// Load the environment variables
  ///
  await dotenv.load(fileName: ".env");

  ///
  /// Load the theme cubit
  ///
  final themeCubit = ThemeCubit();
  themeCubit.loadTheme();

  ///
  /// Set the system UI mode
  ///
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  ///
  /// Set the preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  ///
  /// enable notification permissions
  ///

  await PermissionManager().requestNotificationPermissions();

  //  final pushNotificationService = PushNotificationService();
  // await pushNotificationService.initialize();

  FCMService.initialize();

  ///
  /// Check if the welcome page has been watched
  ///
  bool isWelcomeWatched = await getWelcomePageWatched();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  // run the app
  runApp(MediTouchApp(
    themeCubit: themeCubit,
    isLoggedIn: isLoggedIn,
    isWelcomeWatched: isWelcomeWatched,
  ));
}
