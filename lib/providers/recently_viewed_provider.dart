import 'package:ecom_app/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentlyViewedNotifier extends StateNotifier<List<Product>> {
  RecentlyViewedNotifier() : super([]);

  void addToRecentlyViewedList(Product product) {
    if (!isProductExitsInRecentlyViewedList(product)) {
      state = [product, ...state];
    }
  }

  bool isProductExitsInRecentlyViewedList(Product product) {
    return state.contains(product);
  }

  void clearRecentlyViewedList() {
    state = [];
  }
}

final recentlyViewedListProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<Product>>((ref) {
  return RecentlyViewedNotifier();
});
