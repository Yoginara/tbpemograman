import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String loginStatusKey = 'loginStatusKey';
  static const String loginTimeKey = 'loginTimeKey';
  static const String usernameKey = 'username';

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(loginStatusKey) ?? false;
    String? loginTimeString = prefs.getString(loginTimeKey);
    if (isLoggedIn && loginTimeString != null) {
      try {
        DateTime loginTime = DateTime.parse(loginTimeString);
        final Duration timeDifference = DateTime.now().difference(loginTime);
        const Duration maxDuration = Duration(hours: 4);
        if (timeDifference > maxDuration) {
          await logout();
          return false;
        }
        return true;
      } catch (e) {
        debugPrint('Error parsing DateTime: \$e');
        await logout();
        return false;
      }
    }
    return false;
  }

  static Future<void> login(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(loginStatusKey, true);
    prefs.setString(loginTimeKey, DateTime.now().toString());
    prefs.setString(usernameKey, username);
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data login
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }
}
