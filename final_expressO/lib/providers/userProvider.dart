import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _isLoaded = false;

  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoaded => _isLoaded;

  Future<void> loadUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = jsonDecode(userJson);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/tioLogin', (route) => false);
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setUser(Map<String, dynamic> user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));
    // _isLoaded = true;
    notifyListeners();
  }

  Future<void> clearUser(BuildContext context) async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();

    // 👇 Push login screen and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(context, '/tioLogin', (route) => false);
  }
}
