import 'package:hive_flutter/hive_flutter.dart';

Future<bool> getWelcomePageWatched() async {
    final settingsBox = await Hive.openBox('settings');
    return settingsBox.get('watchedWelcomePage', defaultValue: false);
  }