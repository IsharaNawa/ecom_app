import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/widgets/empty_bag.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  const ViewedRecentlyScreen({super.key});

  @override
  State<ViewedRecentlyScreen> createState() => ViewedRecentlyScreenState();
}

class ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool isRecentlyViewdListEmpty = false;

  @override
  Widget build(BuildContext context) {
    return isRecentlyViewdListEmpty
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
                  HugeIcons.strokeRoundedArrowLeft01,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            body: EmptyBag(
              mainImage: const Icon(
                HugeIcons.strokeRoundedTimeQuarterPass,
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
                    HugeIcons.strokeRoundedArrowLeft01,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              title: const Text("Recently Viewed Items(6)"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isRecentlyViewdListEmpty = true;
                    });
                  },
                  icon: const Icon(
                      HugeIcons.strokeRoundedShoppingBasketCheckOut01),
                  label: const Text("Clear Items"),
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
