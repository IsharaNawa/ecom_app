import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/app_title.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailsScreens extends StatelessWidget {
  const ProductDetailsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.canPop(context) ? Navigator.of(context).pop() : null;
          },
          icon: Icon(
            IconManager.backButtonIcon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: const AppTitle(
          fontSize: 24.0,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              IconManager.wishListGeneralIcon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FancyShimmerImage(
                imageUrl:
                    "https://cdn.pixabay.com/photo/2020/09/02/03/26/iphone-5537230_640.jpg",
                height: 300,
                width: double.infinity,
                boxFit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Text(
                "Apple IPhone 16 Pro Max Japan Edition" * 2,
                style: GoogleFonts.inter(
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Text(
                "\$200.00",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    "*In Phones",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Text(
                "Conducted a redesign of the Dyson Store's mobile app, implementing numerous new features and improvements. This initiative introduced an intuitive interface, optimized product search capabilities, personalized recommendation systems, and various enhancements to ensure an effortless and enjoyable shopping experience for users." *
                    10,
                style: GoogleFonts.lato(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          width: size.width - 30,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              elevation: 0,
            ),
            child: Text(
              "Add to Cart",
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
