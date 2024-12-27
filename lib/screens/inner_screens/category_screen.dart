import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/category_product_provider.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/empty_bag.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  List<Product> categorySearchedProducts = [];

  @override
  Widget build(BuildContext context) {
    List<Product> categoryAllProducts = ref
        .watch(categoryProductsProvider.notifier)
        .getCategoryProducts(widget.categoryName);

    return categoryAllProducts.isEmpty
        ? Scaffold(
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
            backButton: TextButton.icon(
              onPressed: () {
                Navigator.of(context).canPop()
                    ? Navigator.of(context).pop()
                    : null;
              },
              icon: Icon(IconManager.screenMiddleBackButtonIcon),
              label: Text(
                "Go Back",
                style: GoogleFonts.oxygen(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
                  "${widget.categoryName}(${_textEditingController.text.isEmpty ? categoryAllProducts.length : categorySearchedProducts.length})"),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _textEditingController,
                    autocorrect: false,
                    onSubmitted: (value) {
                      setState(() {
                        categorySearchedProducts = ref
                            .watch(categoryProductsProvider.notifier)
                            .getCategorySearchedProducts(
                                value, widget.categoryName);
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(IconManager.searhBarIcon),
                      suffixIcon: _textEditingController.text.isEmpty
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                _textEditingController.clear();
                                FocusScope.of(context).unfocus();
                              },
                              child: Icon(IconManager.clearSearchBarIcon),
                            ),
                      suffixIconColor: Colors.red,
                      label: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                        ),
                        child: Text(
                          "Explore Products",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _textEditingController.text.isNotEmpty &&
                          categorySearchedProducts.isEmpty
                      ? const Center(
                          child: Column(
                            children: [
                              Text("No Products Found!"),
                            ],
                          ),
                        )
                      : DynamicHeightGridView(
                          builder: (context, index) {
                            return ProductGridWidget(
                              product: _textEditingController.text.isEmpty
                                  ? categoryAllProducts[index]
                                  : categorySearchedProducts[index],
                            );
                          },
                          itemCount: _textEditingController.text.isEmpty
                              ? categoryAllProducts.length
                              : categorySearchedProducts.length,
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
