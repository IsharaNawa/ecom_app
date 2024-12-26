import 'package:ecom_app/model/cart.dart';
import 'package:ecom_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantityBottomSheet extends ConsumerWidget {
  const QuantityBottomSheet({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 10),
          height: 5,
          width: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 25,
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        ref
                            .read(cartProvider.notifier)
                            .updateQuantityOfCart(cart, index + 1);
                        print(index + 1);
                        Navigator.of(context).canPop()
                            ? Navigator.of(context).pop()
                            : null;
                      },
                      child: Text(
                        (index + 1).toString(),
                        style: GoogleFonts.lato(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
