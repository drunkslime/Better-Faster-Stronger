import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const String __userId = '__userId';

  Future<void> saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(__userId, id);
  }

  Future<int> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(__userId) ?? 0;
  }
}