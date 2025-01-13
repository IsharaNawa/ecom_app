import 'package:ecom_app/providers/order_provider.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomCartWidget extends ConsumerStatefulWidget {
  const BottomCartWidget({super.key, required this.cartSummary});

  final Map<String, dynamic> cartSummary;

  @override
  ConsumerState<BottomCartWidget> createState() => _BottomCartWidgetState();
}

class _BottomCartWidgetState extends ConsumerState<BottomCartWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total (${widget.cartSummary["products"]} products/${widget.cartSummary["items"]} items)",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\$${widget.cartSummary["totalPrice"].toStringAsFixed(2)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await AppFunctions.showErrorOrWarningOrImagePickerDialog(
                      context: context,
                      isWarning: true,
                      mainTitle: "Do you want to place the Order?",
                      icon: Icon(IconManager.generalLogoutIcon),
                      action1Text: "No",
                      action2Text: "Yes",
                      action1Func: () {
                        Navigator.of(context).pop();
                      },
                      action2Func: () async {
                        ref
                            .read(orderProvider.notifier)
                            .placeOrder(context, ref);

                        Navigator.of(context).pop();
                      },
                      ref: ref,
                    );
                  },
                  child: const Text("Checkout"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
