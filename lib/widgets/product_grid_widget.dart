import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ProductGridWidget extends StatefulWidget {
  const ProductGridWidget({super.key});

  @override
  State<ProductGridWidget> createState() => _ProductGridWidgetState();
}

class _ProductGridWidgetState extends State<ProductGridWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        print("navigate to product page");
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              child: FancyShimmerImage(
                imageUrl:
                    "https://cdn.pixabay.com/photo/2020/09/02/03/26/iphone-5537230_640.jpg",
                width: double.infinity,
                height: size.width * 0.43,
                boxFit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Apple IPhone 16 Prodfdf ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    HugeIcons.strokeRoundedHeartAdd,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "\$200.00",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    HugeIcons.strokeRoundedShoppingCart01,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
