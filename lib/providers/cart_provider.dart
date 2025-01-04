import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:ecom_app/model/cart.dart';
import 'package:ecom_app/model/product.dart';

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({});

  void addItemToCart(
      Product product, BuildContext context, WidgetRef ref, int qty) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await AppFunctions.showErrorOrWarningOrImagePickerDialog(
          context: context,
          isWarning: false,
          mainTitle: "You are not authenticated. Please login First!",
          icon: Icon(IconManager.accountErrorIcon),
          action1Text: "OK",
          action2Text: "",
          action1Func: () async {
            Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
          },
          action2Func: () {},
          ref: ref,
        );

        return;
      }
      if (isItemAlreadyExistsInCart(product)) {
        return;
      }

      String cartId = const Uuid().v4();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "userCart": FieldValue.arrayUnion([
          {
            "cartId": cartId,
            "productId": product.productId,
            "quatity": qty,
          }
        ])
      });
    } on FirebaseException catch (error) {
      await AppFunctions.showErrorOrWarningOrImagePickerDialog(
        context: context,
        isWarning: false,
        mainTitle: error.message.toString(),
        icon: Icon(IconManager.accountErrorIcon),
        action1Text: "OK",
        action2Text: "",
        action1Func: () async {
          Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
        },
        action2Func: () {},
        ref: ref,
      );
    } catch (error) {
      await AppFunctions.showErrorOrWarningOrImagePickerDialog(
        context: context,
        isWarning: false,
        mainTitle: error.toString(),
        icon: Icon(IconManager.accountErrorIcon),
        action1Text: "OK",
        action2Text: "",
        action1Func: () async {
          Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
        },
        action2Func: () {},
        ref: ref,
      );
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

  Future<Map<String, Cart>> fetchProducts(
      BuildContext context, WidgetRef ref) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await AppFunctions.showErrorOrWarningOrImagePickerDialog(
          context: context,
          isWarning: false,
          mainTitle: "You are not authenticated. Please login First!",
          icon: Icon(IconManager.accountErrorIcon),
          action1Text: "OK",
          action2Text: "",
          action1Func: () async {
            Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
          },
          action2Func: () {},
          ref: ref,
        );

        return {};
      }

      Map<String, Cart> cartItemsMap = {};

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get()
          .then((userSnapshot) async {
        final userMap = userSnapshot.data() as Map<String, dynamic>;
        final cartItems = userMap["userCart"];

        for (final item in cartItems) {
          String prodId = item["productId"];

          final prodDoc = await FirebaseFirestore.instance
              .collection("products")
              .doc(prodId)
              .get();

          final product_ = Product.fromFirebaseDocumentSnapshot(prodDoc);

          cartItemsMap[prodId] = Cart(
            cartId: item["cartId"],
            product: product_,
            quantity: item["quatity"],
          );
        }
      });

      state = cartItemsMap;

      return state;
    } on FirebaseException catch (error) {
      return {};
    } catch (error) {
      return {};
    }
  }

  void deleteItemFromCart(Product product) {
    final updatedState = Map<String, Cart>.from(state);

    if (isItemAlreadyExistsInCart(product)) {
      updatedState.remove(product.productId);
    }

    state = updatedState;
  }

  void clearItemFromCart() {
    state = {};
  }

  bool isItemAlreadyExistsInCart(Product product) {
    List<Cart> carts = state.values.toList();
    List<Cart> foundCart = carts
        .where((cart) => cart.product.productId == product.productId)
        .toList();
    return foundCart.isNotEmpty;
  }

  Map<String, dynamic> getCartSummary() {
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

  void updateQuatityOfItemInCart(Cart cart, int qty) {
    String correctProductId = "";
    for (Cart currCart in state.values.toList()) {
      if (currCart.product.productId == cart.product.productId) {
        correctProductId = currCart.product.productId;
      }
    }

    if (correctProductId == "") return;

    final updatedState = Map<String, Cart>.from(state);

    updatedState.update(
      correctProductId,
      (cartItem) => Cart(
        cartId: correctProductId,
        product: state[correctProductId]!.product,
        quantity: qty,
      ),
    );

    state = updatedState;
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});
