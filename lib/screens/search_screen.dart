import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/product_provider.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
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

  List<Product> searchedProducts = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Icon(
              IconManager.appBarIcon,
            ),
          ),
          title: const Text("Explore Products"),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("products")
                .orderBy(
                  "createdAt",
                  descending: true,
                )
                .snapshots(),
            builder: (context, snapshot) {
              ref.watch(productsProvider.notifier).fetchProducts();

              List<Product> allProducts = [];

              if (snapshot.data == null) {
                return const Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        Text(
                          "No product in the catelog!",
                        ),
                      ],
                    ),
                  ),
                );
              }

              for (var element in snapshot.data!.docs) {
                allProducts.add(Product.fromFirebaseDocumentSnapshot(element));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        Text(
                          snapshot.error.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _textEditingController,
                      autocorrect: false,
                      onSubmitted: (value) {
                        print(searchedProducts.length);

                        setState(() {
                          searchedProducts = ref
                              .watch(productsProvider.notifier)
                              .getSearchedProducts(value);
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
                  const SizedBox(height: 10),
                  allProducts.isEmpty
                      ? const Text(
                          "No Products in the Catelog! Please check later.")
                      : Expanded(
                          child: _textEditingController.text.isNotEmpty &&
                                  searchedProducts.isEmpty
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
                                      product:
                                          _textEditingController.text.isEmpty
                                              ? allProducts[index]
                                              : searchedProducts[index],
                                    );
                                  },
                                  itemCount: _textEditingController.text.isEmpty
                                      ? allProducts.length
                                      : searchedProducts.length,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                ),
                        )
                ],
              );
            }),
      ),
    );
  }
}
