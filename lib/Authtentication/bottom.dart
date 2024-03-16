import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class BottomNav extends StatelessWidget {
  void Function(int)? OnTabChange;
  BottomNav({super.key, required this.OnTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GNav(onTabChange: (value) => OnTabChange!(value), tabs: const [
        GButton(
            icon: Icons.home,
            text: 'Home',
            iconColor: Color.fromRGBO(253, 3, 3, 3)),
        GButton(
            icon: Icons.add_box_rounded,
            text: 'Create',
            iconColor: Color.fromRGBO(253, 3, 3, 3)),
        GButton(
            icon: Icons.history_rounded,
            text: 'Histroy',
            iconColor: Color.fromRGBO(253, 3, 3, 3)),
        GButton(
            icon: Icons.person,
            text: 'profile',
            iconColor: Color.fromRGBO(253, 3, 3, 3))
      ]),
    );
  }
}
