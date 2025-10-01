import 'package:flutter/material.dart';
import 'package:selena/screen/auth/verification.dart';
import 'package:selena/screen/journal/journal.dart';

import '/screen/auth/login.dart';
import '/screen/auth/register.dart';
import '../screen/chat/chat.dart';
import '../screen/comunity/comunity.dart';
import '../screen/dashboard/dashboard.dart';

class SejenakRoute {
  static final Map<String, WidgetBuilder> routes = {
    '/comunity': (context) => Comunity(),
    '/dashboard': (context) => Dashboard(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => RegisterScreen(),
    '/chat': (context) => Chat(),
    '/journal': (context) => Journal(),
  };
}
