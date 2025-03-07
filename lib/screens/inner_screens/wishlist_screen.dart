import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/providers/product_provider.dart';
import 'package:ecom_app/screens/generic_screens/error_screen.dart';
import 'package:ecom_app/screens/generic_screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/model/product.dart';

import 'package:ecom_app/providers/wishlist_provider.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/screens/generic_screens/empty_bag_screen.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';

class WishListScreen extends ConsumerStatefulWidget {
  const WishListScreen({super.key});

  @override
  ConsumerState<WishListScreen> createState() => WishListScreenState();
}

class WishListScreenState extends ConsumerState<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    List<Product> wishListItemList = [];

    if (user == null) {
      return const ErrorScreen(
        errorTitle: "No Authenticated User Found!",
      );
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          ref
              .watch(wishListProvider.notifier)
              .fetchProductsForWishList(context, ref);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(
              loadingText: "Loading your wishlist...",
            );
          }

          if (snapshot.hasError) {
            return ErrorScreen(errorTitle: snapshot.error.toString());
          }

          if (snapshot.data == null || !snapshot.hasData) {
            return EmptyBagScreen(
              mainImage: Icon(
                IconManager.emptyWishListIcon,
                size: 200,
              ),
              mainTitle: "Nothing is in Your Wishlist!",
              subTitle:
                  "You have not added any items to the wishlist. Please add items to your wishlist and they will appear here.",
              buttonText: "Explore Products",
              buttonFunction: () {},
            );
          }

          final userMap = snapshot.data!.data() as Map<String, dynamic>;

          if (!userMap.containsKey("userWishList")) {
            return const ErrorScreen(
                errorTitle: "userWishList key not in this user");
          }

          final wishListItemsFromFirebase = userMap["userWishList"];

          for (final prodId in wishListItemsFromFirebase) {
            Product product_ =
                ref.read(productsProvider.notifier).findProductById(prodId);

            wishListItemList.add(product_);
          }

          if (wishListItemList.isEmpty) {
            return EmptyBagScreen(
              mainImage: Icon(
                IconManager.emptyCartIcon,
                size: 200,
              ),
              mainTitle: "Nothing is in Your Cart!",
              subTitle:
                  "You have not added any items to the cart. Please add items to your cart and checkout when you are ready.",
              buttonText: "Explore Products",
              buttonFunction: () {},
            );
          }

          return Scaffold(
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
              title: Text("WishList(${wishListItemList.length})"),
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
                          ref
                              .read(wishListProvider.notifier)
                              .clearWishList(context, ref);
                        });
                        Navigator.of(context).pop();
                      },
                      ref: ref,
                    );
                  },
                  icon: Icon(IconManager.clearWishListIcon),
                  label: const Text("Clear Wishlist"),
                )
              ],
            ),
            body: DynamicHeightGridView(
              builder: (context, index) {
                return ProductGridWidget(product: wishListItemList[index]);
              },
              itemCount: wishListItemList.length,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
          );
        });
  }
}
