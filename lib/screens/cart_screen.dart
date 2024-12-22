import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Icon(
                  HugeIcons.strokeRoundedShoppingCartRemove01,
                  size: 200,
                ),
              ),
              const Text(
                "No Order Placed Yet!",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
                child: Text(
                  "You have not placed an order yet. Please add items to your cart and checkout when you are ready.",
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 17,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.2,
                    vertical: 20,
                  ),
                ),
                child: Text(
                  "Explore Products",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
