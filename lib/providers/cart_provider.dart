import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/providers/product_provider.dart';
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

  Future<void> addItemToCart(
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
      if (isProductAlreadyExistsInCart(product)) {
        return;
      }

      String cartId = const Uuid().v4();
      Timestamp createdAt = Timestamp.now();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "userCart": FieldValue.arrayUnion([
          {
            "cartId": cartId,
            "productId": product.productId,
            "quatity": qty,
            "createdAt": createdAt,
          }
        ])
      });

      state = {
        product.productId: Cart(
          cartId: const Uuid().v4(),
          product: product,
          quantity: 1,
          createdAt: createdAt,
        ),
        ...state
      };
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
  }

  Future<Map<String, Cart>> fetchProducts(
      BuildContext context, WidgetRef ref) async {
    Map<String, Cart> cartItemsMap = {};
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

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get()
          .then((userSnapshot) async {
        if (userSnapshot.data() == null) return {};

        final userMap = userSnapshot.data() as Map<String, dynamic>;

        if (!userMap.containsKey("userCart")) return {};

        final cartItems = userMap["userCart"];

        for (final item in cartItems) {
          String prodId = item["productId"];

          Product product_ =
              ref.read(productsProvider.notifier).findProductById(prodId);

          cartItemsMap[prodId] = Cart(
              cartId: item["cartId"],
              product: product_,
              quantity: item["quatity"],
              createdAt: item["createdAt"]);
        }
      });

      state = cartItemsMap;

      return state;
    } on FirebaseException catch (error) {
      print(error.message.toString());
      return {};
    } catch (error) {
      print(error.toString());
      return {};
    }
  }

  Future<void> deleteItemFromCart(
      Product product, BuildContext context, WidgetRef ref) async {
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

      if (!isProductAlreadyExistsInCart(product)) {
        return;
      }

      Cart? cartItem = state[product.productId];

      if (cartItem == null) {
        return;
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "userCart": FieldValue.arrayRemove([
          {
            "cartId": cartItem.cartId,
            "productId": product.productId,
            "quatity": cartItem.quantity,
            "createdAt": cartItem.createdAt,
          }
        ])
      });

      final updatedState = Map<String, Cart>.from(state);

      if (isProductAlreadyExistsInCart(product)) {
        updatedState.remove(product.productId);
      }

      state = updatedState;
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
  }

  Future<void> clearItemFromCart(BuildContext context, WidgetRef ref) async {
    state = {};

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

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"userCart": []});

      state = {};
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
  }

  bool isProductAlreadyExistsInCart(Product product) {
    print("state" + state.toString());
    List<Cart> carts = state.values.toList();
    print(state);
    List<Cart> foundCart = carts
        .where((cart) => cart.product.productId == product.productId)
        .toList();

    print(foundCart.length);
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
        createdAt: state[correctProductId]!.createdAt,
      ),
    );

    state = updatedState;
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});
