import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveRepository {
  static const String _userInfoBox = 'userInfoBox';
  static const String _userInfoKey = 'userInfo';
  static const String _userSearchBox = 'userSearchBox';
  static const String _searchHistoryKey = 'searchHistory';

  // ValueListenable to listen for changes in the user info box
  ValueListenable<Box<Map>> get userInfoBoxListener {
    return Hive.box<Map>(_userInfoBox).listenable();
  }

  // Initialize the Hive box
  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Ensure the box is opened only once
    if (!Hive.isBoxOpen(_userInfoBox)) {
      await Hive.openBox<Map>(_userInfoBox);
    }

    // Ensure the box is opened only once
    if (!Hive.isBoxOpen(_userSearchBox)) {
      await Hive.openBox<List<String>>(_userSearchBox);
    }
  }

  // Save user info to Hive
  Future<void> saveUserInfo(String id, String name, String email, String gender,
      String dob, String image, String phone) async {
    final userInfoBox = Hive.box<Map>(_userInfoBox);
    final userInfo = {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'dob': dob,
      'image': image,
      'phone': phone,
    };
    await userInfoBox.put(_userInfoKey, userInfo);
  }

  // Retrieve user info from Hive
  Future<Map<String, dynamic>?> getUserInfo() async {
    final userInfoBox = Hive.box<Map>(_userInfoBox);
    final dynamic userInfo = userInfoBox.get(_userInfoKey);

    if (userInfo is Map) {
      return Map<String, dynamic>.from(userInfo);
    }
    return null;
  }

  // Delete user info from Hive
  Future<void> deleteUserInfo() async {
    final userInfoBox = Hive.box<Map>(_userInfoBox);
    await userInfoBox.delete(_userInfoKey);
  }

  // Update user info in Hive
  Future<void> updateUserInfo(Map<String, dynamic> updatedData) async {
    final userInfoBox = Hive.box<Map>(_userInfoBox);
    final userInfo = userInfoBox.get(_userInfoKey);

    if (userInfo is Map) {
      userInfo.addAll(updatedData);
      await userInfoBox.put(_userInfoKey, userInfo);
    }
  }

  // Save user search history to Hive
  Future<void> saveUserSearchHistory(String searchQuery) async {
    final searchBox = Hive.box<List<String>>(_userSearchBox);
    final history = searchBox.get(_searchHistoryKey, defaultValue: <String>[])!;

    // Avoid duplicates in history
    if (!history.contains(searchQuery)) {
      history.add(searchQuery);
      await searchBox.put(_searchHistoryKey, history);

      print('Search history saved:  $history');
    }
  }

  // Retrieve user search history from Hive
  Future<List<String>> getUserSearchHistory() async {
    final searchBox = Hive.box<List<String>>(_userSearchBox);
    return searchBox.get(_searchHistoryKey, defaultValue: <String>[])!;
  }

  // retrieve user search history from Hive realtime
  ValueListenable<Box<List<String>>> getUserSearchHistoryListenable() {
    final searchBox = Hive.box<List<String>>(_userSearchBox);
    return searchBox.listenable();
  }

  // Delete all user search history
  Future<void> deleteUserSearchHistory() async {
    final searchBox = Hive.box<List<String>>(_userSearchBox);
    await searchBox.delete(_searchHistoryKey);
  }

  // Delete a specific search query from history
  Future<void> deleteSpecificSearchQuery(String searchQuery) async {
    final searchBox = Hive.box<List<String>>(_userSearchBox);
    final history = searchBox.get(_searchHistoryKey, defaultValue: <String>[])!;

    if (history.contains(searchQuery)) {
      history.remove(searchQuery);
      await searchBox.put(_searchHistoryKey, history);
    }
  }
}
