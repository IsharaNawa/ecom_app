import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class AppFunctions {
  static Future<void> showErrorOrWarningDialog({
    required BuildContext context,
    required bool isWarning,
    required String mainTitle,
    required Icon icon,
    required String action1Text,
    required String action2Text,
    required Function action1Func,
    required Function action2Func,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: icon,
          title: Text(
            mainTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 18,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      action1Func();
                    },
                    child: Text(
                      action1Text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Visibility(
                  visible: isWarning,
                  child: const SizedBox(
                    width: 16,
                  ),
                ),
                Visibility(
                  visible: isWarning,
                  child: Flexible(
                    child: TextButton(
                      onPressed: () {
                        action2Func();
                      },
                      child: Text(
                        action2Text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
