import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selena/root/sejenak_color.dart';

class SejenakNavbar extends StatelessWidget {
  final int index;
  const SejenakNavbar({super.key, this.index = 0});
  void _onItemTapped(BuildContext context, int selectedIndex) {
    String route = '/';

    if (selectedIndex == 0) {
      route = '/comunity';
    } else if (selectedIndex == 1) {
      route = '/dashboard';
    } else if (selectedIndex == 2) {
      route = '/journal';
    } else if (selectedIndex == 3) {
      route = '/chat';
    }

    if (ModalRoute.of(context)!.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (selectedIndex) => _onItemTapped(context, selectedIndex),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/svg/post_icon.svg",
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              index == 0 ? SejenakColor.secondary : SejenakColor.stroke,
              BlendMode.srcIn,
            ),
          ),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/svg/meditation_icon.svg",
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              index == 1 ? SejenakColor.secondary : SejenakColor.stroke,
              BlendMode.srcIn,
            ),
          ),
          label: 'Meditasi',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/svg/journal_icon.svg",
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              index == 2 ? SejenakColor.secondary : SejenakColor.stroke,
              BlendMode.srcIn,
            ),
          ),
          label: 'Journal',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/svg/chat_icon.svg",
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              index == 3 ? SejenakColor.secondary : SejenakColor.stroke,
              BlendMode.srcIn,
            ),
          ),
          label: 'Chat',
        ),
      ],
    );
  }
}
