import 'package:ecom_app/model/cart.dart';
import 'package:ecom_app/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({});

  void createNewCartItem(Product product) {
    if (isCartWithSameProductExits(product)) {
      return;
    }

    state = {
      product.productId: Cart(
        cartId: const Uuid().v4(),
        product: product,
        quantity: 1,
      ),
      ...state
    };
  }

  void clearCarts() {
    state = {};
  }

  bool isCartWithSameProductExits(Product product) {
    List<Cart> carts = state.values.toList();
    List<Cart> foundCart = carts
        .where((cart) => cart.product.productId == product.productId)
        .toList();
    return foundCart.isNotEmpty;
  }

  Map<String, dynamic> getOverallCartSummary() {
    List<Cart> carts = state.values.toList();
    double totalPrice = 0.0;
    int items = 0;

    for (Cart cart in carts) {
      totalPrice += cart.quantity * double.parse(cart.product.productPrice);
      items += cart.quantity;
    }

    int products = carts.length;

    return {"totalPrice": totalPrice, "products": products, "items": items};
  }

  void updateQuantityOfCart(Cart cart, int qty) {
    String correctCartId = "";
    for (Cart currCart in state.values.toList()) {
      if (currCart.product.productId == cart.product.productId) {
        correctCartId = currCart.cartId;
      }
    }

    if (correctCartId == "") return;

    state.update(
        correctCartId,
        (cartItem) => Cart(
            cartId: correctCartId,
            product: state[correctCartId]!.product,
            quantity: qty));

    state = {};
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});
