import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/providers/product_provider.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/model/product.dart';

class WishListNotifier extends StateNotifier<List<Product>> {
  WishListNotifier() : super([]);

  Future<void> addToWishList(
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
      if (isProductExitsInWishList(product)) {
        return;
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "userWishList": FieldValue.arrayUnion([product.productId])
      });

      state = [product, ...state];
    } on FirebaseException catch (error) {
      if (!context.mounted) return;
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
      if (!context.mounted) return;
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

  Future<List<Product>> fetchProductsForWishList(
      BuildContext context, WidgetRef ref) async {
    List<Product> wishListProducts = [];
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

        return [];
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get()
          .then((userSnapshot) async {
        if (userSnapshot.data() == null) return [];

        final userMap = userSnapshot.data() as Map<String, dynamic>;

        if (!userMap.containsKey("userWishList")) return [];

        final userWishList = userMap["userWishList"];

        for (final prodId in userWishList) {
          Product foundProduct =
              ref.read(productsProvider.notifier).findProductById(prodId);
          wishListProducts.add(foundProduct);
        }
      });

      state = wishListProducts;

      return state;
    } on FirebaseException catch (error) {
      print(error.message.toString());
      return [];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  bool isProductExitsInWishList(Product product) {
    return state.contains(product);
  }

  Future<void> clearWishList(BuildContext context, WidgetRef ref) async {
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
          .update({"userWishList": []});

      state = [];
    } on FirebaseException catch (error) {
      if (!context.mounted) return;
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
      if (!context.mounted) return;
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

final wishListProvider =
    StateNotifierProvider<WishListNotifier, List<Product>>((ref) {
  return WishListNotifier();
});
