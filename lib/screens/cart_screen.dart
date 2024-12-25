import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/cart_screen_widgets/bottom_cart_widget.dart';
import 'package:ecom_app/widgets/cart_screen_widgets/cart_widget.dart';
import 'package:ecom_app/widgets/empty_bag.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isCartEmpty = false;

  @override
  Widget build(BuildContext context) {
    return isCartEmpty
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
              title: const Text("Your Cart(6)"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isCartEmpty = true;
                    });
                  },
                  icon: Icon(IconManager.clearCartIcon),
                  label: const Text("Clear Cart"),
                )
              ],
            ),
            body: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const CartWidget();
              },
            ),
            bottomSheet: const BottomCartWidget(),
          );
  }
}
