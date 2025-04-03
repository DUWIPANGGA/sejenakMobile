import 'package:flutter/material.dart';
import 'package:selena/app/components/sejenak_calendar.dart';
import 'package:selena/app/components/sejenak_text.dart';
import 'package:selena/app/partial/sejenak_navbar.dart';
import 'package:selena/models/user_models/user_models.dart';
import 'package:selena/session/user_session.dart';

class Dashboard extends StatelessWidget {
  final UserModels? user;

  Dashboard({super.key}) : user = UserSession().user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SejenakText(
              text: "meditasi",
              type: SejenakTextType.h1,
            ),
            SejenakCalendar()
          ],
        ),
      ),
      bottomNavigationBar: SejenakNavbar(index: 1),
    );
  }
}
