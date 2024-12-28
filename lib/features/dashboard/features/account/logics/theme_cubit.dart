import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<bool> {
  Box? preferencesBox;

  ThemeCubit() : super(false) {
    _initialize();
  }

  // Initialize the cubit and load the theme from Hive
  Future<void> _initialize() async {
    preferencesBox = await Hive.openBox('settings');
    loadTheme();
  }

  // Load the theme from Hive storage
  Future<void> loadTheme() async {
    // Ensure preferencesBox is initialized before loading the theme
    if (preferencesBox != null) {
      emit(preferencesBox!.get('darkMode', defaultValue: false));
    }
  }

  // Toggle the dark mode and store the preference
  Future<void> toggleTheme() async {
    if (preferencesBox != null) {
      final currentTheme = preferencesBox!.get('darkMode', defaultValue: false);
      await preferencesBox!.put('darkMode', !currentTheme);
      emit(!currentTheme);
    }
  }
}
