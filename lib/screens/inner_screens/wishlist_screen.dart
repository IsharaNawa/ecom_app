import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/providers/wishlist_provider.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/empty_bag.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishListScreen extends ConsumerStatefulWidget {
  const WishListScreen({super.key});

  @override
  ConsumerState<WishListScreen> createState() => WishListScreenState();
}

class WishListScreenState extends ConsumerState<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkmodeOn = ref.watch(darkModeThemeStatusProvider);
    List<Product> wishListProducts = ref.watch(wishListProvider);

    return wishListProducts.isEmpty
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
              title: Text("WishList(${wishListProducts.length})"),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    await AppFunctions.showErrorOrWarningOrImagePickerDialog(
                      context: context,
                      isWarning: true,
                      mainTitle: "Do you want to clear Wishlist?",
                      icon: Icon(IconManager.clearWishListIcon),
                      action1Text: "No",
                      action2Text: "Yes",
                      action1Func: () {
                        Navigator.of(context).pop();
                      },
                      action2Func: () {
                        setState(() {
                          ref.read(wishListProvider.notifier).clearWishList();
                        });
                        Navigator.of(context).pop();
                      },
                      isDarkmodeOn: isDarkmodeOn,
                    );
                  },
                  icon: Icon(IconManager.clearWishListIcon),
                  label: const Text("Clear Wishlist"),
                )
              ],
            ),
            body: DynamicHeightGridView(
              builder: (context, index) {
                return ProductGridWidget(product: wishListProducts[index]);
              },
              itemCount: wishListProducts.length,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
          );
  }
}
