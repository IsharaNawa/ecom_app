import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/empty_bag.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';
import 'package:flutter/material.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => WishListScreenState();
}

class WishListScreenState extends State<WishListScreen> {
  bool isWishListEmpty = false;

  @override
  Widget build(BuildContext context) {
    return isWishListEmpty
        ? Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.canPop(context)
                      ? Navigator.of(context).pop()
                      : null;
                },
                icon: Icon(
                  IconManager.backButtonIcon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            body: EmptyBag(
              mainImage: Icon(
                IconManager.emptyWishListIcon,
                size: 200,
              ),
              mainTitle: "Nothing is in Your Wishlist!",
              subTitle:
                  "You have not added any items to the wishlist. Please add items to your wishlist and they will appear here.",
              buttonText: "Explore Products",
              buttonFunction: () {},
            ))
        : Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              leading: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.canPop(context)
                        ? Navigator.of(context).pop()
                        : null;
                  },
                  icon: Icon(
                    IconManager.backButtonIcon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              title: const Text("WishList(6)"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isWishListEmpty = true;
                    });
                  },
                  icon: Icon(IconManager.clearWishListIcon),
                  label: const Text("Clear Wishlist"),
                )
              ],
            ),
            body: DynamicHeightGridView(
              builder: (context, index) {
                return const ProductGridWidget();
              },
              itemCount: 200,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
          );
  }
}
