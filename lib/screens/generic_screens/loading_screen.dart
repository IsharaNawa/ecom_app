import 'package:ecom_app/widgets/app_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
    this.loadingText,
    this.isIncludeAppTitle,
  });

  final String? loadingText;
  final bool? isIncludeAppTitle;

  @override
  Widget build(BuildContext context) {
    List<Widget> appTitleList = [];

    if (isIncludeAppTitle != null && isIncludeAppTitle == true) {
      appTitleList.add(
        const AppTitle(fontSize: 30),
      );
    }

    List<Widget> content = loadingText != null
        ? [
            const SizedBox(
              height: 20,
            ),
            Text(
              loadingText!,
              style: GoogleFonts.oxygen(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ]
        : [const SizedBox.shrink()];
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...appTitleList,
            ...content,
            const SizedBox(
              height: 30,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
