import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/core/utils/app_color.dart';
import 'package:velo_toulouse_redesign/views/screens/map_screen.dart';
import 'package:velo_toulouse_redesign/views/screens/user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const _screens = [
    MapScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined, color: AppColor.primaryColor,),
            activeIcon: Icon(Icons.map, color: AppColor.primaryColor),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline,color: AppColor.primaryColor),
            activeIcon: Icon(Icons.person, color: AppColor.primaryColor),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
