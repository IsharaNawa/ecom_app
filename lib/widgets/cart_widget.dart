import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/widgets/quantity_bottom_sheet.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: themeProvider.getIsDarkTheme
            ? const Color.fromARGB(255, 10, 10, 10)
            : const Color.fromARGB(255, 250, 250, 250),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FancyShimmerImage(
                imageUrl:
                    "https://cdn.pixabay.com/photo/2014/01/22/19/38/boot-250012_1280.jpg",
                height: 100,
                width: 100,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.63,
                    child: Text(
                      "Hershel Supply fd fdfjdfjd fkdjfffffffffddf" * 13,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Column(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedDelete04,
                        size: 18,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Icon(
                        HugeIcons.strokeRoundedHeartAdd,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: size.width * 0.64,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$100.50",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const QuantityBottomSheet();
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      label: Text(
                        "Qty : 01",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        HugeIcons.strokeRoundedArrowDown01,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
