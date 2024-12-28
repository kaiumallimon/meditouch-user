import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveRepository {
  static const String _userInfoBox = 'userInfoBox';
  static const String _userInfoKey = 'userInfo';


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
}
