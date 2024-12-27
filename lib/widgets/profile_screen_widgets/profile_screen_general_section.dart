import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/recently_viewed_provider.dart';
import 'package:ecom_app/providers/wishlist_provider.dart';
import 'package:ecom_app/screens/inner_screens/orders_screen.dart';
import 'package:ecom_app/screens/inner_screens/viewed_recently_screen.dart';
import 'package:ecom_app/screens/inner_screens/wishlist_screen.dart';
import 'package:ecom_app/services/icon_manager.dart';

class ProfileScreenGeneralSection extends ConsumerWidget {
  const ProfileScreenGeneralSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product> recentlyViewedProducts =
        ref.watch(recentlyViewedListProvider);
    List<Product> wishListProducts = ref.watch(wishListProvider);
    List<dynamic> leadingIcons = [
      Icon(IconManager.ordersIcon),
      wishListProducts.isNotEmpty
          ? Badge(
              label: Text(wishListProducts.length.toString()),
              child: Icon(IconManager.wishListGeneralIcon),
            )
          : Icon(IconManager.wishListGeneralIcon),
      recentlyViewedProducts.isNotEmpty
          ? Badge(
              label: Text(recentlyViewedProducts.length.toString()),
              child: Icon(IconManager.recentlyViewedIcon),
            )
          : Icon(IconManager.wishListGeneralIcon),
      Icon(IconManager.addressIcon),
    ];

    List<String> titles = [
      "All orders",
      "Wishlist",
      "Viewed Recently",
      "Address"
    ];

    List<dynamic> buttonFunctions = [
      () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const OrdersScreen(),
          ),
        );
      },
      () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const WishListScreen(),
          ),
        );
      },
      () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ViewedRecentlyScreen(),
          ),
        );
      },
      () {},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Text(
            "General",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        ...leadingIcons.map(
          (icon) => GestureDetector(
            onTap: buttonFunctions[leadingIcons.indexOf(icon)],
            child: ListTile(
              leading: icon,
              title: Text(titles[leadingIcons.indexOf(icon)]),
              trailing: const Icon(Icons.arrow_right),
            ),
          ),
        ),
        const Divider(
          indent: 10,
          endIndent: 10,
          thickness: 0.8,
        ),
      ],
    );
  }
}
