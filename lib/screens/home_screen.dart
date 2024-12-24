import 'package:ecom_app/widgets/app_title.dart';
import 'package:ecom_app/widgets/home_screen_widgets/carousel_section.dart';
import 'package:ecom_app/widgets/home_screen_widgets/category_section.dart';
import 'package:ecom_app/widgets/home_screen_widgets/latest_arrival_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Icon(
            HugeIcons.strokeRoundedShoppingBag02,
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
                      return const Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          LatestArrivalItem()
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
