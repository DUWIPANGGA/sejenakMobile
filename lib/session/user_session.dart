import 'dart:convert';
import 'package:selena/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:selena/models/user_models/user_models.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  UserModels? _user;
  static const String _userKey = 'user_data';

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  Future<void> setUser(UserModels user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  UserModels? get user => _user;

 Future<void> loadUserFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(_userKey);

  if (jsonString != null) {
    final jsonData = jsonDecode(jsonString);
    print("Data dari SharedPreferences = $jsonData");

    _user = UserModels.fromJson(jsonData);
  DioHttpClient.getInstance().setToken(_user!.token!);
  } else {
    print("Tidak ada data user di SharedPreferences.");
  }
}


  Future<void> clearUser() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  bool get isLoggedIn => _user != null;
}
