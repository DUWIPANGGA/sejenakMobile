import 'package:flutter/material.dart';
import 'package:selena/app/component/sejenak_primary_button.dart';
import 'package:selena/app/component/sejenak_text.dart';
import 'package:selena/models/user_models/user_models.dart';
import 'package:selena/root/sejenak_color.dart';

class SejenakSidebar extends StatelessWidget {
  final UserModels? user;
  const SejenakSidebar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      backgroundColor: SejenakColor.white,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            children: <Widget>[
              ListTileTheme(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=3'),
                      ),
                    ),
                    SejenakText(
                      text: user!.user!.username!,
                      type: SejenakTextType.h5,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 28, left: 13),
                child: Column(
                  children: [
                    SejenakPrimaryButton(
                      text: "profil",
                      action: () async {},
                      icon: 'assets/svg/profil_default.svg',
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    SejenakPrimaryButton(
                      text: "notifikasi",
                      action: () async {},
                      icon: 'assets/svg/notification.svg',
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    SejenakPrimaryButton(
                      text: "pengaturan",
                      action: () async {},
                      icon: 'assets/svg/settings.svg',
                    ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
