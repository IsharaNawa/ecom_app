import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/model/category.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = [
      Category(
        name: "Phones",
        id: "0",
        categoryIcon: const Icon(
          HugeIcons.strokeRoundedSmartPhone01,
          size: 40,
        ),
      ),
      Category(
        name: "Laptops",
        id: "1",
        categoryIcon: const Icon(
          HugeIcons.strokeRoundedLaptop,
          size: 40,
        ),
      ),
      Category(
        name: "Electronics",
        id: "2",
        categoryIcon: const Icon(
          HugeIcons.strokeRoundedPlug01,
          size: 40,
        ),
      ),
      Category(
        name: "Watches",
        id: "3",
        categoryIcon: const Icon(
          HugeIcons.strokeRoundedSmartWatch04,
          size: 40,
        ),
      ),
      Category(
        name: "Clothes",
        id: "4",
        categoryIcon: const Icon(
          HugeIcons.strokeRoundedClothes,
          size: 40,
        ),
      ),
      Category(
        name: "Shoes",
        id: "5",
        categoryIcon: const Icon(
          HugeIcons.strokeRoundedRunningShoes,
          size: 40,
        ),
      ),
      Category(
        name: "Books",
        id: "6",
        categoryIcon: const Icon(
          HugeIcons.strokeRoundedBook04,
          size: 40,
        ),
      ),
      Category(
        name: "Makeup",
        id: "7",
        categoryIcon: const Icon(
          HugeIcons.strokeRoundedAiBeautify,
          size: 40,
        ),
      ),
    ];

    return SizedBox(
      height: 140,
      child: DynamicHeightGridView(
        builder: (context, index) {
          return Center(
            child: Column(
              children: [
                categories[index].categoryIcon,
                Text(
                  categories[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: categories.length,
        crossAxisCount: 5,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
    );
  }
}
