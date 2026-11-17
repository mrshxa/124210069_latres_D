import 'package:shared_preferences/shared_preferences.dart';

/// Session login disimpan di SharedPreferences.
class SessionService {
  static const _keyUser = 'username';

  static Future<void> login(String username) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyUser, username);
  }

  static Future<String?> getUsername() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyUser);
  }

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyUser);
  }
}
