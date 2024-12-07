import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveRepository {
  static const String _userInfoBox = 'userInfoBox';
  static const String _userInfoKey = 'userInfo';

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Ensure the box is opened only once
    if (!Hive.isBoxOpen(_userInfoBox)) {
      await Hive.openBox<Map>(_userInfoBox);
    }
  }

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

  Future<Map<String, dynamic>?> getUserInfo() async {
    final userInfoBox = Hive.box<Map>(_userInfoBox);
    final dynamic userInfo = userInfoBox.get(_userInfoKey);

    if (userInfo is Map) {
      return Map<String, dynamic>.from(userInfo);
    }
    return null;
  }

  Future<void> deleteUserInfo() async {
    final userInfoBox = Hive.box<Map>(_userInfoBox);
    await userInfoBox.delete(_userInfoKey);
  }
}
