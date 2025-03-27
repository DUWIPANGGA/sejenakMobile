import 'package:flutter/material.dart';
import 'package:selena/root/sejenak_color.dart';
import 'package:selena/screen/landing_page/landing_page.dart';

import 'routes/routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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

        if (builder != null) {
          return PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                builder(context),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        }
        return null;
      },
      home: Landingpage(),
    );
  }
}
