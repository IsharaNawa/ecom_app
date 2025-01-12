import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/product_provider.dart';
import 'package:ecom_app/screens/generic_screens/error_screen.dart';

import 'package:ecom_app/screens/generic_screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom_app/model/cart.dart';
import 'package:ecom_app/providers/cart_provider.dart';

import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/cart_screen_widgets/bottom_cart_widget.dart';
import 'package:ecom_app/widgets/cart_screen_widgets/cart_widget.dart';
import 'package:ecom_app/screens/generic_screens/empty_bag_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    List<Cart> cartsList = [];

    if (user == null) {
      return const ErrorScreen(
        errorTitle: "No Authenticated User Found!",
      );
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          ref.watch(cartProvider.notifier).fetchProducts(context, ref);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(
              loadingText: "Loading your cart...",
            );
          }

          if (snapshot.hasError) {
            return ErrorScreen(errorTitle: snapshot.error.toString());
          }

          if (snapshot.data == null || !snapshot.hasData) {
            return EmptyBagScreen(
              mainImage: Icon(
                IconManager.emptyCartIcon,
                size: 200,
              ),
              mainTitle: "Nothing is in Your Cart!",
              subTitle:
                  "You have not added any items to the cart. Please add items to your cart and checkout when you are ready.",
              buttonText: "Explore Products",
              buttonFunction: () {},
            );
          }

          final userMap = snapshot.data!.data() as Map<String, dynamic>;

          if (!userMap.containsKey("userCart")) {
            return const ErrorScreen(
                errorTitle: "userCart key not in this user");
          }

          final cartItems = userMap["userCart"];

          Map<String, Cart> cartItemsMap = {};

          for (final prodId in cartItems.keys) {
            Product product_ =
                ref.read(productsProvider.notifier).findProductById(prodId);

            cartItemsMap[prodId] = Cart(
              cartId: cartItems[prodId]["cartId"],
              product: product_,
              quantity: cartItems[prodId]["quatity"],
              createdAt: cartItems[prodId]["createdAt"],
            );
          }

          cartsList = cartItemsMap.values.toList();

          cartsList.sort((a, b) {
            return b.createdAt.compareTo(a.createdAt);
          });

          Map<String, dynamic> cartsSummaryMap = {};

          double totalPrice = 0.0;
          int items = 0;

          for (Cart cart in cartsList) {
            totalPrice +=
                cart.quantity * double.parse(cart.product.productPrice);
            items += cart.quantity;
          }

          int products = cartsList.length;

          cartsSummaryMap = {
            "totalPrice": totalPrice,
            "products": products,
            "items": items
          };

          if (cartsList.isEmpty) {
            return EmptyBagScreen(
              mainImage: Icon(
                IconManager.emptyCartIcon,
                size: 200,
              ),
              mainTitle: "Nothing is in Your Cart!",
              subTitle:
                  "You have not added any items to the cart. Please add items to your cart and checkout when you are ready.",
              buttonText: "Explore Products",
              buttonFunction: () {},
            );
          }

          return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Icon(
                    IconManager.appBarIcon,
                  ),
                ),
                title: Text("Your Cart(${cartsList.length})"),
                actions: [
                  TextButton.icon(
                    onPressed: () async {
                      await AppFunctions.showErrorOrWarningOrImagePickerDialog(
                        context: context,
                        isWarning: true,
                        mainTitle: "Do you want to clear Cart?",
                        icon: Icon(IconManager.clearCartIcon),
                        action1Text: "No",
                        action2Text: "Yes",
                        action1Func: () {
                          Navigator.of(context).pop();
                        },
                        action2Func: () {
                          setState(
                            () {
                              ref.read(cartProvider.notifier).clearItemFromCart(
                                    context,
                                    ref,
                                  );
                            },
                          );

                          Navigator.of(context).pop();
                        },
                        ref: ref,
                      );
                    },
                    icon: Icon(IconManager.clearCartIcon),
                    label: const Text("Clear Cart"),
                  )
                ],
              ),
              body: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: cartsList.length,
                itemBuilder: (context, index) {
                  return CartWidget(
                    cartItem: cartsList[index],
                  );
                },
              ),
              bottomSheet: BottomCartWidget(
                cartSummary: cartsSummaryMap,
              ));
        });
  }
}
