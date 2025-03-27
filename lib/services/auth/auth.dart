import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../app/components/sejenak_error.dart';
import '../../models/user_models/user.dart';
import '../../models/user_models/user_models.dart';
import '../../session/user_session.dart';
import '../api.dart';
import '../controller.dart';

abstract class SejenakAuth {
  Future<void> login(BuildContext context);
  Future<void> signOut();
}

abstract class AuthWithRegister {
  Future<void> register(BuildContext context);
}

class SejenakApiAuthService implements SejenakAuth, AuthWithRegister {
  final AuthFormController formController;
  final DioHttpClient auth = HttpClientBuilder().withDio(Dio()).build();
  final API api = API();
  SejenakApiAuthService(this.formController) {}

  @override
  Future<void> login(BuildContext context) async {
    print(
        "name: ${formController.name.text} password ${formController.password.text}");
    try {
      final response = await auth.post(
        api.login,
        data: {
          "email": formController.name.text,
          "password": formController.password.text,
        },
      );

      print("Response: ${response.data}");

      if (response.statusCode == 200) {
        UserSession().setUser(UserModels(
          code: response.data["code"] ?? "",
          status: response.data["status"] ?? "",
          token: response.data["token"] ?? "",
          user: response.data["user"] is Map<String, dynamic>
              ? User.fromJson(response.data["user"] as Map<String, dynamic>)
              : null,
        ));

        Navigator.pushReplacementNamed(context, '/comunity');
      }
    } catch (e) {
      if (e is DioException) {
        print("Dio Error: ${e.response?.statusCode}");
        print("Message: ${e.response?.data}");
        showErrorDialog(context, "login gagal! Silakan coba lagi!");
      } else {
        print("Error: $e");
      }
    }
  }

  @override
  Future<void> register(BuildContext context) async {
    try {
      final response = await auth.post(api.register, data: {
        'name': formController.name.text,
        'username': formController.username.text,
        'email': formController.email.text,
        'password': formController.password.text,
        'password_confirmation': formController.passwordVerification.text,
      });
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (e is DioException) {
        print("Dio Error: ${e.response?.statusCode}");
        print("Message: ${e.response?.data}");
        showErrorDialog(context, "register gagal! Silakan coba lagi!");
      }
    }
  }

  @override
  Future<void> signOut() async {
    print("sign out");
  }
}

class GoogleAuthService implements SejenakAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        "226311772731-v7ohhv9hp30v706ud0uj9t55uacftkjj.apps.googleusercontent.com",
  );
  @override
  Future<void> login(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
    } catch (e) {
      showErrorDialog(context, "login gagal! Silakan coba lagi!");
      print("Google Sign-In Error: $e");
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
