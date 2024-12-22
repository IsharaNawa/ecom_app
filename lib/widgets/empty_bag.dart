import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class EmptyBag extends StatelessWidget {
  EmptyBag({
    super.key,
    required this.mainImage,
    required this.mainTitle,
    required this.subTitle,
    required this.buttonText,
    required this.buttonFunction,
  });

  Widget mainImage;
  String mainTitle;
  String subTitle;
  String buttonText;
  final void Function() buttonFunction;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: mainImage,
            ),
            Text(
              mainTitle,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
              child: Text(
                subTitle,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 17,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: buttonFunction,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.2,
                  vertical: 20,
                ),
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
