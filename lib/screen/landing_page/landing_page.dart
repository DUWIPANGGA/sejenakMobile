import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:selena/app/component/sejenak_primary_button.dart';
import 'package:selena/app/component/sejenak_text.dart';
import 'package:selena/root/sejenak_color.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 64, right: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 64,
              ),
              SvgPicture.asset(
                'assets/svg/logo_mini.svg',
                width: 40,
                height: 37,
                colorFilter: ColorFilter.mode(
                  SejenakColor.primary,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SvgPicture.asset(
                'assets/svg/icon.svg',
                width: 221,
                height: 220,
              ),
              SizedBox(
                height: 97,
              ),
              SejenakText(
                text: 'Luangkan sejenak waktu untuk diri anda',
                type: SejenakTextType.h5,
              ),
              SizedBox(
                height: 11,
              ),
              SejenakPrimaryButton(
                  text: 'Masuk dengan google',
                  icon: 'assets/svg/google.svg',
                  action: () async {
                    Navigator.pushNamed(context, '/register');
                  }),
              SizedBox(
                height: 11,
              ),
              SejenakPrimaryButton(
                  text: 'Masuk dengan email',
                  icon: 'assets/svg/mail.svg',
                  action: () async {
                    Navigator.pushNamed(context, '/login');
                  }),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SejenakText(text: "belum punya akun?"),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/dashboard');
                      },
                      child: Text(
                        " buat disini",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 14, 82, 137),
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 64,
              ),
              Text(
                "Dengan membuat akun, anda setuju dengan Kebijakan Penggunaan kamu dan memahami bahwa Kebijakan Privasi kami ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: SejenakColor.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
