import 'dart:convert';
import 'package:firebase_nexus/helpers/adminPageSupabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final supabaseHelper = AdminSupabaseHelper();

  Future<List<Map<String, dynamic>>>? loadCategs() async {
    try {
      final categories = await supabaseHelper.getAll("Categories");
      return categories;
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }
 }
