import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/product_provider.dart';
import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/model/cart.dart';
import 'package:ecom_app/providers/cart_provider.dart';
import 'package:ecom_app/screens/cart_screen.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/profile_screen.dart';
import 'package:ecom_app/screens/search_screen.dart';
import 'package:ecom_app/services/icon_manager.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  late List<Widget> _screens;
  late int _currentScreen;
  late PageController _pageController;
  List<Product>? products;
  bool isLoadingProd = true;

  Future<void> fetchProducts(bool isDarkmodeOn) async {
    try {
      Future.wait({ref.watch(productsProvider.notifier).fetchProducts()});
    } catch (error) {
      if (!mounted) return;
      AppFunctions.showErrorOrWarningOrImagePickerDialog(
        context: context,
        isWarning: false,
        mainTitle: "Error Occured when fetching products!",
        icon: Icon(IconManager.productFetchingErrorIcon),
        action1Text: "OK",
        action2Text: "",
        action1Func: () async {
          Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
        },
        action2Func: () {},
        ref: ref,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _screens = const [
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    _currentScreen = 0;
    _pageController = PageController(initialPage: _currentScreen);
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      bool isDarkmodeOn = ref.watch(darkModeThemeStatusProvider);
      fetchProducts(isDarkmodeOn);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Cart> cartItemsMap = ref.watch(cartProvider);

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
            icon: cartItemsMap.values.toList().isNotEmpty
                ? Badge(
                    label: Text(cartItemsMap.values.toList().length.toString()),
                    child: Icon(IconManager.addToCartGeneralIcon),
                  )
                : Icon(IconManager.addToCartGeneralIcon),
            label: "Cart",
            selectedIcon: cartItemsMap.values.toList().isNotEmpty
                ? Badge(
                    label: Text(cartItemsMap.values.toList().length.toString()),
                    child: Icon(IconManager.cartActiveNavbarIcon),
                  )
                : Icon(IconManager.cartActiveNavbarIcon),
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
