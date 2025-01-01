import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecom_app/model/category.dart';
import 'package:ecom_app/screens/inner_screens/category_screen.dart';

class CategorySection extends ConsumerWidget {
  const CategorySection({super.key});

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
                  categoryName: Category.CATEGORIES[index].name,
                );
              }));
            },
            child: Center(
              child: Column(
                children: [
                  Category.CATEGORIES[index].categoryIcon,
                  Text(
                    Category.CATEGORIES[index].name,
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
        itemCount: Category.CATEGORIES.length,
        crossAxisCount: 5,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
    );
  }
}
