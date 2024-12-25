import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/search_screen_widgets/product_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Icon(
              IconManager.appBarIcon,
            ),
          ),
          title: const Text("Explore Products"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _textEditingController,
                autocorrect: false,
                onSubmitted: (value) {
                  print(_textEditingController.text);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(IconManager.searhBarIcon),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _textEditingController.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(IconManager.clearSearchBarIcon),
                  ),
                  suffixIconColor: Colors.red,
                  label: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Text(
                      "Explore Products",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: DynamicHeightGridView(
                builder: (context, index) {
                  return const ProductGridWidget();
                },
                itemCount: 200,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
