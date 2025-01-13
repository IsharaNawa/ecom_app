import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/model/cart.dart';
import 'package:ecom_app/model/order.dart';
import 'package:ecom_app/providers/cart_provider.dart';
import 'package:ecom_app/providers/product_provider.dart';
import 'package:ecom_app/providers/user_provider.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/model/product.dart';
import 'package:uuid/uuid.dart';

class OrderNotifier extends StateNotifier<List<OrderProduct>> {
  OrderNotifier() : super([]);

  Future<void> placeOrder(BuildContext context, WidgetRef ref) async {
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

      Map<String, dynamic> cartProducts = ref.watch(cartProvider);
      for (final prodId in cartProducts.keys) {
        Cart cart_ = cartProducts[prodId];
        String orderId = const Uuid().v4();
        String userId = user.uid;

        Product product_ =
            ref.read(productsProvider.notifier).findProductById(prodId);

        String? userName = ref.read(userProvider).userId;

        if (userName == null) {
          print("Null username error");
          return;
        }

        Timestamp orderDate = Timestamp.now();

        double price = cart_.quantity * double.parse(product_.productPrice);

        await FirebaseFirestore.instance.collection("orders").doc(orderId).set({
          "userId": userId,
          "productId": prodId,
          "productTitle": product_.productTitle,
          "userName": userName,
          "price": price,
          "imageUrl": product_.productImage,
          "quantity": cart_.quantity,
          "orderDate": orderDate,
        });

        OrderProduct orderProduct_ = OrderProduct(
          orderId: orderId,
          userId: userId,
          productId: product_.productId,
          productTitle: product_.productTitle,
          userName: userName,
          price: price.toString(),
          imageUrl: product_.productImage,
          quantity: cart_.quantity.toString(),
          orderDate: orderDate,
        );

        state = [orderProduct_, ...state];

        ref.read(cartProvider.notifier).clearItemFromCart(context, ref);
      }
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

  Future<List<OrderProduct>> fetchOrders(
      BuildContext context, WidgetRef ref) async {
    List<OrderProduct> ordersList = [];
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
          .collection("orders")
          .get()
          .then((userSnapshot) async {
        if (userSnapshot.docs.isEmpty) return [];

        String? userId = ref.read(userProvider).userId;

        for (final doc in userSnapshot.docs) {
          Map<String, dynamic> orderData = doc.data();

          if (userId != orderData["userId"]) {
            continue;
          }

          String orderId = doc.id;

          OrderProduct orderProduct_ = OrderProduct(
            orderId: orderId,
            userId: orderData["userId"],
            productId: orderData["productId"],
            productTitle: orderData["productTitle"],
            userName: orderData["userName"],
            price: orderData["price"].toString(),
            imageUrl: orderData["imageUrl"],
            quantity: orderData["quantity"],
            orderDate: orderData["orderDate"],
          );

          ordersList.add(orderProduct_);
        }
      });

      state = ordersList;

      return state;
    } on FirebaseException catch (error) {
      print(error.message.toString());
      return [];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
}

final orderProvider =
    StateNotifierProvider<OrderNotifier, List<OrderProduct>>((ref) {
  return OrderNotifier();
});
