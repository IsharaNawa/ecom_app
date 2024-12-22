import 'package:ecom_app/widgets/empty_bag.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyBag(
        mainImage: const Icon(
          HugeIcons.strokeRoundedShoppingCartRemove01,
          size: 200,
        ),
        mainTitle: "Nothing is in Your Cart!",
        subTitle:
            "You have not placed an order yet. Please add items to your cart and checkout when you are ready.",
        buttonText: "Explore Products",
        buttonFunction: () {},
      ),
    );
  }
}
