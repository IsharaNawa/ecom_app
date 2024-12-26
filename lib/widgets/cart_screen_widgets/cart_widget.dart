import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/cart_screen_widgets/quantity_bottom_sheet.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FancyShimmerImage(
              imageUrl: product.productImage,
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
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        product.productTitle,
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
                        Icon(
                          IconManager.wishListGeneralIcon,
                          size: 18,
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
                        "\$${product.productPrice}",
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
                            return const QuantityBottomSheet();
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
                            "Qty : 01",
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
