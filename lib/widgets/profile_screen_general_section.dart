import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileScreenGeneralSection extends StatelessWidget {
  const ProfileScreenGeneralSection({super.key});

  @override
  Widget build(BuildContext context) {
    List<Icon> leadingIcons = const [
      Icon(HugeIcons.strokeRoundedShoppingBag01),
      Icon(HugeIcons.strokeRoundedHeartAdd),
      Icon(HugeIcons.strokeRoundedClock02),
      Icon(HugeIcons.strokeRoundedLocation03)
    ];

    List<String> titles = [
      "All orders",
      "Wishlist",
      "Viewed Recently",
      "Address"
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
          (icon) => ListTile(
            leading: icon,
            title: Text(titles[leadingIcons.indexOf(icon)]),
            trailing: const Icon(Icons.arrow_right),
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