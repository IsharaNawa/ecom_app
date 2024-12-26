import 'package:ecom_app/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryProductNotifier extends StateNotifier<List<Product>> {
  CategoryProductNotifier() : super(Product.products);

  List<Product> getCategoryProducts(String category) {
    return state
        .where((product) => product.productCategory == category)
        .toList();
  }
}

final categoryProductsProvider =
    StateNotifierProvider<CategoryProductNotifier, List<Product>>((ref) {
  return CategoryProductNotifier();
});
