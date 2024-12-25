import 'package:ecom_app/screens/cart_screen.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/profile_screen.dart';
import 'package:ecom_app/screens/search_screen.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> _screens;
  late int _currentScreen;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _screens = const [
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    _currentScreen = 3;
    _pageController = PageController(initialPage: _currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Colors.transparent,
        selectedIndex: _currentScreen,
        onDestinationSelected: (index) {
          setState(() {
            _currentScreen = index;
          });
          _pageController.jumpToPage(_currentScreen);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(IconManager.homeNavBarIcon),
            label: "Home",
            selectedIcon: Icon(IconManager.homeActiveNavBarIcon),
          ),
          NavigationDestination(
            icon: Icon(IconManager.searchNavbarIcon),
            label: "Search",
            selectedIcon: Icon(IconManager.searchActiveNavbarIcon),
          ),
          NavigationDestination(
            icon: Badge(
              label: const Text("3"),
              child: Icon(IconManager.addToCartGeneralIcon),
            ),
            label: "Cart",
            selectedIcon: Icon(IconManager.cartActiveNavbarIcon),
          ),
          NavigationDestination(
            icon: Icon(IconManager.profileNavBarIcon),
            label: "Profile",
            selectedIcon: Icon(IconManager.profileActiveNavBarIcon),
          ),
        ],
      ),
    );
  }
}
