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
        "userCart.${product.productId}": {
          "cartId": cartId,
          "quatity": qty,
          "createdAt": createdAt,
        },
      });

      state = {
        product.productId: Cart(
          cartId: cartId,
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

        for (final prodId in cartItems.keys) {
          Product product_ =
              ref.read(productsProvider.notifier).findProductById(prodId);

          cartItemsMap[prodId] = Cart(
              cartId: cartItems[prodId]["cartId"],
              product: product_,
              quantity: cartItems[prodId]["quatity"],
              createdAt: cartItems[prodId]["createdAt"]);
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

      print(cartItem.toString());

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"userCart.${product.productId}": FieldValue.delete()});

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
          .update({"userCart": {}});

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

  Future<void> updateQuatityOfItemInCart(
      Cart cart, int qty, BuildContext context, WidgetRef ref) async {
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
          .update({
        "userCart.${cart.product.productId}": {
          "cartId": cart.cartId,
          "quatity": qty,
          "createdAt": cart.createdAt,
        }
      });

      final updatedState = Map<String, Cart>.from(state);

      updatedState.update(
        cart.product.productId,
        (cartItem) => Cart(
          cartId: cart.cartId,
          product: state[cart.product.productId]!.product,
          quantity: qty,
          createdAt: cart.createdAt,
        ),
      );

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
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});
