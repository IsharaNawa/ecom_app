import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/providers/product_provider.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/model/product.dart';

class RecentlyViewedNotifier extends StateNotifier<List<Product>> {
  RecentlyViewedNotifier() : super([]);

  Future<void> addToRecentlyViewedList(
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

      if (isProductExitsInRecentlyViewedList(product)) {
        return;
      }

      print("add to recently");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "recentlyViewed": FieldValue.arrayUnion([product.productId])
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

  Future<List<Product>> fetchProductsForRecentlyViewedList(
      BuildContext context, WidgetRef ref) async {
    List<Product> recentlyViewedListProducts = [];
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

        if (!userMap.containsKey("recentlyViewed")) return [];

        final userRecentlyViewedList = userMap["recentlyViewed"];

        for (final prodId in userRecentlyViewedList) {
          Product foundProduct =
              ref.read(productsProvider.notifier).findProductById(prodId);
          recentlyViewedListProducts.add(foundProduct);
        }
      });

      state = recentlyViewedListProducts;

      return state;
    } on FirebaseException catch (error) {
      print(error.message.toString());
      return [];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  bool isProductExitsInRecentlyViewedList(Product product) {
    return state.contains(product);
  }

  Future<void> clearRecentlyViewedList(
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

        return;
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"recentlyViewed": []});

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

final recentlyViewedListProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<Product>>((ref) {
  return RecentlyViewedNotifier();
});
