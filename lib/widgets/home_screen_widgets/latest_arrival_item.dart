import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/cart_provider.dart';
import 'package:ecom_app/providers/wishlist_provider.dart';
import 'package:ecom_app/screens/inner_screens/product_details_screen.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LatestArrivalItem extends ConsumerWidget {
  const LatestArrivalItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailsScreens(
                product: product,
              );
            },
          ),
        );
      },
      child: SizedBox(
        width: size.width * 0.4,
        child: Material(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: FancyShimmerImage(
                      imageUrl: product.productImage,
                      height: size.width * 0.43,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        product.productTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              AppFunctions.showListRelatedSnackBar(
                                context,
                                product,
                                ref,
                                ref
                                    .read(wishListProvider.notifier)
                                    .isProductExitsInWishList(product),
                                'This item is already in the wishlist!',
                                'Item is added to the wishlist',
                                "wishlist",
                              );
                            },
                            icon: Icon(
                              IconManager.wishListGeneralIcon,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              AppFunctions.showListRelatedSnackBar(
                                  context,
                                  product,
                                  ref,
                                  ref
                                      .read(cartProvider.notifier)
                                      .isCartWithSameProductExits(product),
                                  'This item is already in the cart!',
                                  'Item is added to the cart',
                                  "cart");
                            },
                            icon: Icon(
                              IconManager.addToCartGeneralIcon,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "\$${product.productPrice}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
