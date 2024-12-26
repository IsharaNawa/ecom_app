import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/empty_bag.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
    required this.categoryProducts,
    required this.categoryName,
  });

  final List<Product> categoryProducts;
  final String categoryName;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.categoryProducts.isEmpty
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
                IconManager.emptyOrdersListIcon,
                size: 200,
              ),
              mainTitle: "No products in this category!",
              subTitle:
                  "There are no products in this category at the moment. Please check later for updates.",
              buttonText: "Explore Products",
              buttonFunction: () {},
            ))
        : Scaffold(
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
              title: Text(
                  "${widget.categoryName}(${widget.categoryProducts.length})"),
            ),
            body: Column(
              children: [
                Expanded(
                  child: DynamicHeightGridView(
                    builder: (context, index) {
                      return ProductGridWidget(
                        product: widget.categoryProducts[index],
                      );
                    },
                    itemCount: widget.categoryProducts.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                )
              ],
            ),
          );
  }
}
