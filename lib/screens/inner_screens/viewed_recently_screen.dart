import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/providers/product_provider.dart';
import 'package:ecom_app/screens/generic_screens/error_screen.dart';
import 'package:ecom_app/screens/generic_screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/recently_viewed_provider.dart';

import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/screens/generic_screens/empty_bag_screen.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';

class ViewedRecentlyScreen extends ConsumerStatefulWidget {
  const ViewedRecentlyScreen({super.key});

  @override
  ConsumerState<ViewedRecentlyScreen> createState() =>
      ViewedRecentlyScreenState();
}

class ViewedRecentlyScreenState extends ConsumerState<ViewedRecentlyScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    List<Product> recentlyViewedItemsList = [];

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
              .watch(recentlyViewedListProvider.notifier)
              .fetchProductsForRecentlyViewedList(context, ref);
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
                IconManager.emptyRecentlyViewedIcon,
                size: 200,
              ),
              mainTitle: "You haven't viewed any products yet!",
              subTitle:
                  "You have not viewed any products. Please explore products and then they will appear here.",
              buttonText: "Explore Products",
              buttonFunction: () {},
            );
          }

          final userMap = snapshot.data!.data() as Map<String, dynamic>;

          if (!userMap.containsKey("recentlyViewed")) {
            return const ErrorScreen(
                errorTitle: "recentlyViewed key not in this user");
          }

          final recentlyViewedItemsListFromFirebase = userMap["recentlyViewed"];

          for (final prodId in recentlyViewedItemsListFromFirebase) {
            Product product_ =
                ref.read(productsProvider.notifier).findProductById(prodId);

            recentlyViewedItemsList.add(product_);
          }

          if (recentlyViewedItemsList.isEmpty) {
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
              title: Text(
                  "Recently Viewed Items(${recentlyViewedItemsList.length})"),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    await AppFunctions.showErrorOrWarningOrImagePickerDialog(
                      context: context,
                      isWarning: true,
                      mainTitle: "Do you want to clear recently viewed items?",
                      icon: Icon(IconManager.clearRecentelyViewedList),
                      action1Text: "No",
                      action2Text: "Yes",
                      action1Func: () {
                        Navigator.of(context).pop();
                      },
                      action2Func: () {
                        setState(() {
                          ref
                              .read(recentlyViewedListProvider.notifier)
                              .clearRecentlyViewedList(context, ref);
                        });
                        Navigator.of(context).pop();
                      },
                      ref: ref,
                    );
                  },
                  icon: Icon(IconManager.clearRecentelyViewedList),
                  label: const Text("Clear Items"),
                )
              ],
            ),
            body: DynamicHeightGridView(
              builder: (context, index) {
                return ProductGridWidget(
                    product: recentlyViewedItemsList[index]);
              },
              itemCount: recentlyViewedItemsList.length,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
          );
        });
  }
}
