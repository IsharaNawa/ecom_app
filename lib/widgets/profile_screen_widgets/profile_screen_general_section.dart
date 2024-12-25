import 'package:ecom_app/screens/inner_screens/viewed_recently.dart';
import 'package:ecom_app/screens/inner_screens/wishlist_screen.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:flutter/material.dart';

class ProfileScreenGeneralSection extends StatelessWidget {
  const ProfileScreenGeneralSection({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> leadingIcons = [
      Icon(IconManager.ordersIcon),
      Badge(
        label: const Text("3"),
        child: Icon(IconManager.wishListGeneralIcon),
      ),
      Badge(
        label: const Text("3"),
        child: Icon(IconManager.recentlyViewedIcon),
      ),
      Icon(IconManager.addressIcon),
    ];

    List<String> titles = [
      "All orders",
      "Wishlist",
      "Viewed Recently",
      "Address"
    ];

    List<dynamic> buttonFunctions = [
      () {},
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
