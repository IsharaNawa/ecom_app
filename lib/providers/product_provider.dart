import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/model/product.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  List<Product> getSearchedProducts(String searchQuery) {
    List<Product> searchedItems = state
        .where((product) => product.productTitle
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    List<Product> searchedInDesc = state
        .where((product) => product.productDescription
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    for (final item in searchedInDesc) {
      if (!searchedItems.contains(item)) {
        searchedItems.add(item);
      }
    }

    return searchedItems;
  }

  Future<List<Product>?> fetchProducts() async {
    try {
      final productDB = FirebaseFirestore.instance.collection("products");
      List<Product> products = [];
      await productDB
          .orderBy(
            "createdAt",
            descending: true,
          )
          .get()
          .then(
        (productSnapshot) {
          for (var element in productSnapshot.docs) {
            products.add(Product.fromFirebaseDocumentSnapshot(element));
          }
        },
      );

      state = products;

      return state;
    } on FirebaseException catch (error) {
      return null;
    } catch (error) {
      return null;
    }
  }
}

final productsProvider =
    StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  return ProductNotifier();
});
