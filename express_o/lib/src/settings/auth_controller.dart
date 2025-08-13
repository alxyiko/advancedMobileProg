import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controls login state for the app.
class AuthController with ChangeNotifier {
  static const _key = 'isLoggedIn';
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  /// Loads login state from SharedPreferences
  Future<void> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  /// Logs the user in and saves state
  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Logs the user out and saves state
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
    _isLoggedIn = false;
    notifyListeners();
  }
}
