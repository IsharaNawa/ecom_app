import 'package:ecom_app/constants/app_colors.dart';
import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecom_app/model/product.dart';
import 'package:ecom_app/providers/cart_provider.dart';
import 'package:ecom_app/providers/wishlist_provider.dart';

class AppFunctions {
  static Future<void> showErrorOrWarningOrImagePickerDialog({
    required BuildContext context,
    required bool isWarning,
    required String mainTitle,
    required Icon icon,
    required String action1Text,
    required String action2Text,
    required Function action1Func,
    required Function action2Func,
    required WidgetRef ref,
  }) async {
    bool isDarkmodeOn = ref.watch(darkModeThemeStatusProvider);
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
              color: isDarkmodeOn ? Colors.white : Colors.black,
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

  static Future<void> showListRelatedSnackBar(
    BuildContext context,
    Product product,
    WidgetRef ref,
    bool isAlreayExists,
    String alreayExistMessage,
    String successfullyAddedMessage,
    String type,
    int qty,
  ) async {
    if (isAlreayExists) {
      print("in snackbar");
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: Text(
              alreayExistMessage,
              style: GoogleFonts.lato(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            duration: const Duration(milliseconds: 1500),
          ),
        );
    } else {
      if (type == "cart") {
        ref.read(cartProvider.notifier).addItemToCart(
              product,
              context,
              ref,
              qty,
            );
      } else if (type == "wishlist") {
        ref
            .read(wishListProvider.notifier)
            .addToWishList(product, context, ref);
      } else if (type == "recently_viewd") {
      } else if (type == "cartRemoval") {
        ref
            .read(cartProvider.notifier)
            .deleteItemFromCart(product, context, ref);
      }

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
            successfullyAddedMessage,
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          duration: const Duration(milliseconds: 1500),
        ));
    }
  }

  static Future<void> triggerErrorDialog({
    required BuildContext context,
    required WidgetRef ref,
    required String errorMessage,
  }) async {
    await AppFunctions.showErrorOrWarningOrImagePickerDialog(
      context: context,
      isWarning: false,
      mainTitle: errorMessage,
      icon: Icon(IconManager.accountErrorIcon),
      action1Text: "OK",
      action2Text: "",
      action1Func: () async {
        Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
      },
      action2Func: () {},
      ref: ref,
    );
  }

  static Future<void> triggerToast(
    String toastText,
    WidgetRef ref,
  ) async {
    await Fluttertoast.showToast(
      msg: "Your account is created!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: ref.watch(darkModeThemeStatusProvider)
          ? AppColors.lightScaffoldColor
          : AppColors.darkScaffoldColor,
      textColor: ref.watch(darkModeThemeStatusProvider)
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor,
      fontSize: 16.0,
    );
  }
}
