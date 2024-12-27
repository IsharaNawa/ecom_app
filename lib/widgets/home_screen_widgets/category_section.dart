import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecom_app/model/category.dart';
import 'package:ecom_app/screens/inner_screens/category_screen.dart';
import 'package:ecom_app/services/icon_manager.dart';

class CategorySection extends ConsumerWidget {
  CategorySection({super.key});

  final List<Category> categories = [
    Category(
      name: "Phones",
      id: "0",
      categoryIcon: Icon(
        IconManager.phoneCategoryIcon,
        size: 40,
      ),
    ),
    Category(
      name: "Laptops",
      id: "1",
      categoryIcon: Icon(
        IconManager.laptopCategoryIcon,
        size: 40,
      ),
    ),
    Category(
      name: "Electronics",
      id: "2",
      categoryIcon: Icon(
        IconManager.electronicsCategoryIcon,
        size: 40,
      ),
    ),
    Category(
      name: "Watches",
      id: "3",
      categoryIcon: Icon(
        IconManager.watchCategoryIcon,
        size: 40,
      ),
    ),
    Category(
      name: "Clothes",
      id: "4",
      categoryIcon: Icon(
        IconManager.clotheCategoryIcon,
        size: 40,
      ),
    ),
    Category(
      name: "Shoes",
      id: "5",
      categoryIcon: Icon(
        IconManager.shoeCategoryIcon,
        size: 40,
      ),
    ),
    Category(
      name: "Books",
      id: "6",
      categoryIcon: Icon(
        IconManager.bookCategoryIcon,
        size: 40,
      ),
    ),
    Category(
      name: "Makeup",
      id: "7",
      categoryIcon: Icon(
        IconManager.makeupCategoryIcon,
        size: 40,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 140,
      child: DynamicHeightGridView(
        builder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CategoryScreen(
                  categoryName: categories[index].name,
                );
              }));
            },
            child: Center(
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
