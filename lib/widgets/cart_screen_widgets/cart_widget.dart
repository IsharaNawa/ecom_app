import 'package:ecom_app/model/cart.dart';
import 'package:ecom_app/providers/wishlist_provider.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/cart_screen_widgets/quantity_bottom_sheet.dart';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CartWidget extends ConsumerWidget {
  const CartWidget({super.key, required this.cartItem});

  final Cart cartItem;

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
              imageUrl: cartItem.product.productImage,
              height: 100,
              width: 100,
              boxFit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: size.width - 130,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        cartItem.product.productTitle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        Icon(
                          IconManager.removeItemFromCartIcon,
                          size: 18,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppFunctions.showListRelatedSnackBar(
                              context,
                              cartItem.product,
                              ref,
                              ref
                                  .read(wishListProvider.notifier)
                                  .isProductExitsInWishList(cartItem.product),
                              'This item is already in the wishlist!',
                              'Item is added to the wishlist',
                              "wishlist",
                            );
                          },
                          child: Icon(
                            IconManager.wishListGeneralIcon,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "\$${cartItem.product.productPrice}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return QuantityBottomSheet(cart: cartItem);
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            IconManager.openCartQuantityBottomSheetIcon,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Qty : ${cartItem.quantity}",
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
