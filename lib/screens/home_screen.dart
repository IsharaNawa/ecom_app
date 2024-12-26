import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/product_provider.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/app_title.dart';
import 'package:ecom_app/widgets/home_screen_widgets/carousel_section.dart';
import 'package:ecom_app/widgets/home_screen_widgets/category_section.dart';
import 'package:ecom_app/widgets/home_screen_widgets/latest_arrival_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product> products = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Icon(
            IconManager.appBarIcon,
          ),
        ),
        title: const AppTitle(
          fontSize: 24.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarouselSection(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Latest Arrivals",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 105,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 4.0,
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          LatestArrivalItem(
                            product: products[index],
                          )
                        ],
                      );
                    },
                    itemCount: 20,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 25, bottom: 16),
                child: Text(
                  "Categories",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const CategorySection(),
            ],
          ),
        ),
      ),
    );
  }
}
