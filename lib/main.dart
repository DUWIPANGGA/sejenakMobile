import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:selena/firebase_options.dart';
import 'package:selena/root/sejenak_color.dart';
import 'package:selena/screen/landing_page/landing_page.dart';
import 'package:selena/session/user_session.dart';

import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final isLoggedIn = UserSession().isLoggedIn;
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: SejenakColor.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: SejenakColor.white,
            selectedItemColor: SejenakColor.secondary,
            unselectedItemColor: SejenakColor.stroke,
            selectedLabelStyle:
                TextStyle(fontSize: 12, fontFamily: 'Lexend', wordSpacing: 0.4),
            unselectedLabelStyle:
                TextStyle(fontSize: 12, fontFamily: 'Lexend', wordSpacing: 0.4),
          )),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
  WidgetBuilder? builder = SejenakRoute.routes[settings.name];

  if (builder == null) return null;

  if (settings.name == '/profile' || settings.name == '/profile') {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: Duration(milliseconds: 400),
    );
  } else {
    // tanpa animasi
    return MaterialPageRoute(builder: builder, settings: settings);
  }
},

      home: LandingPage(),
    );
  }
}
