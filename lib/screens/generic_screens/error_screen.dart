import 'package:ecom_app/services/icon_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.errorTitle,
  });

  final String errorTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "An error has occured!",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
              child: Text(
                errorTitle,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 17,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).canPop()
                    ? Navigator.of(context).pop()
                    : null;
              },
              icon: Icon(IconManager.screenMiddleBackButtonIcon),
              label: Text(
                "Go Back",
                style: GoogleFonts.oxygen(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
