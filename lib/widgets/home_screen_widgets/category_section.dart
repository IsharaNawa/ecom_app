import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/model/category.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = [
      Category(
        name: "Phones",
        id: "0",
        categoryIcon: Icon(
          IconManager.phoneCategory,
          size: 40,
        ),
      ),
      Category(
        name: "Laptops",
        id: "1",
        categoryIcon: Icon(
          IconManager.laptopCategory,
          size: 40,
        ),
      ),
      Category(
        name: "Electronics",
        id: "2",
        categoryIcon: Icon(
          IconManager.electronicsCategory,
          size: 40,
        ),
      ),
      Category(
        name: "Watches",
        id: "3",
        categoryIcon: Icon(
          IconManager.watchCategory,
          size: 40,
        ),
      ),
      Category(
        name: "Clothes",
        id: "4",
        categoryIcon: Icon(
          IconManager.clotheCategory,
          size: 40,
        ),
      ),
      Category(
        name: "Shoes",
        id: "5",
        categoryIcon: Icon(
          IconManager.shoeCategory,
          size: 40,
        ),
      ),
      Category(
        name: "Books",
        id: "6",
        categoryIcon: Icon(
          IconManager.bookCategory,
          size: 40,
        ),
      ),
      Category(
        name: "Makeup",
        id: "7",
        categoryIcon: Icon(
          IconManager.makeupCategory,
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
