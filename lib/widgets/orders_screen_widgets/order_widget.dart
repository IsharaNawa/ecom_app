import 'package:ecom_app/model/order.dart';
import 'package:ecom_app/providers/order_provider.dart';
import 'package:ecom_app/services/icon_manager.dart';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderWidget extends ConsumerWidget {
  const OrderWidget({super.key, required this.orderProduct});

  final OrderProduct orderProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FancyShimmerImage(
              imageUrl: orderProduct.imageUrl,
              height: 100,
              width: 100,
            ),
          ),
        ),
        SizedBox(
          width: size.width - 130,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        orderProduct.productTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {
                        {
                          ref
                              .watch(orderProvider.notifier)
                              .deleteOrder(orderProduct, context, ref);
                        }
                      },
                      icon: Icon(IconManager.removeItemFromCartIcon),
                    ),
                  ],
                ),
                Text(
                  "\$${orderProduct.price.toString()}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Row(
                  children: [
                    const Text("Qty: "),
                    Text(
                      orderProduct.quantity.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
