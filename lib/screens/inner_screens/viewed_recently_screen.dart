import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/cart_provider.dart';
import 'package:ecom_app/providers/recently_viewed_provider.dart';
import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/empty_bag.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewedRecentlyScreen extends ConsumerStatefulWidget {
  const ViewedRecentlyScreen({super.key});

  @override
  ConsumerState<ViewedRecentlyScreen> createState() =>
      ViewedRecentlyScreenState();
}

class ViewedRecentlyScreenState extends ConsumerState<ViewedRecentlyScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkmodeOn = ref.watch(darkModeThemeStatusProvider);
    List<Product> recentlyViewedProducts =
        ref.watch(recentlyViewedListProvider);

    return recentlyViewedProducts.isEmpty
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
                IconManager.emptyRecentlyViewedIcon,
                size: 200,
              ),
              mainTitle: "You haven't viewed any products yet!",
              subTitle:
                  "You have not viewed any products. Please explore products and then they will appear here.",
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
              title: Text(
                  "Recently Viewed Items(${recentlyViewedProducts.length})"),
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
                              .clearRecentlyViewedList();
                        });
                        Navigator.of(context).pop();
                      },
                      isDarkmodeOn: isDarkmodeOn,
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
                    product: recentlyViewedProducts[index]);
              },
              itemCount: recentlyViewedProducts.length,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
          );
  }
}
