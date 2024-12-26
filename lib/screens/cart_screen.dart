import 'package:ecom_app/model/cart.dart';
import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/cart_provider.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/cart_screen_widgets/bottom_cart_widget.dart';
import 'package:ecom_app/widgets/cart_screen_widgets/cart_widget.dart';
import 'package:ecom_app/widgets/empty_bag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  List<Cart> cartsList = [];

  @override
  Widget build(BuildContext context) {
    Map<String, Cart> cartItemsMap = ref.watch(cartProvider);
    Map<String, dynamic> cartsSummaryMap =
        ref.watch(cartProvider.notifier).getOverallCartSummary();
    cartsList = cartItemsMap.values.toList();

    return cartsList.isEmpty
        ? Scaffold(
            body: EmptyBag(
            mainImage: Icon(
              IconManager.emptyCartIcon,
              size: 200,
            ),
            mainTitle: "Nothing is in Your Cart!",
            subTitle:
                "You have not added any items to the cart. Please add items to your cart and checkout when you are ready.",
            buttonText: "Explore Products",
            buttonFunction: () {},
          ))
        : Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              leading: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Icon(
                  IconManager.appBarIcon,
                ),
              ),
              title: Text("Your Cart(${cartsList.length})"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      ref.read(cartProvider.notifier).clearCarts();
                    });
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
            ),
          );
  }
}
