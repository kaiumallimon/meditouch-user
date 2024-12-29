import 'package:shared_preferences/shared_preferences.dart';

class SharedRepository {
  Future<String> getBuildId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('medeasyId') ?? '';
  }
}
