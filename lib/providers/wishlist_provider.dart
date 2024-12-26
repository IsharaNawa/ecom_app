import 'package:ecom_app/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishListNotifier extends StateNotifier<List<Product>> {
  WishListNotifier() : super([]);

  void addToWishList(Product product) {
    if (!state.contains(product)) {
      state = [product, ...state];
    }
  }

  void clearWishList() {
    state = [];
  }
}

final wishListProvider =
    StateNotifierProvider<WishListNotifier, List<Product>>((ref) {
  return WishListNotifier();
});
