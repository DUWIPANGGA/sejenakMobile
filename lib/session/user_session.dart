import 'package:selena/models/user_models/user_models.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  UserModels? _user; // Menyimpan data user

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  void setUser(UserModels user) {
    _user = user;
  }

  UserModels? get user => _user;
}
