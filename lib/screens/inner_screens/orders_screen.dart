import 'package:flutter/material.dart';

import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/screens/generic_screens/empty_bag_screen.dart';
import 'package:ecom_app/widgets/orders_screen_widgets/order_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isOrdersListEmpty = true;
  @override
  Widget build(BuildContext context) {
    return isOrdersListEmpty
        ? EmptyBagScreen(
            mainImage: Icon(
              IconManager.emptyOrdersListIcon,
              size: 200,
            ),
            mainTitle: "There are no ongoing orders!",
            subTitle:
                "You dont have any ongoing orders. When you purchase some products, they will appear here.",
            buttonText: "Explore Products",
            buttonFunction: () {},
          )
        : Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              leading: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.canPop(context)
                        ? Navigator.of(context).pop()
                        : null;
                  },
                  icon: Icon(
                    IconManager.backButtonIcon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              title: const Text("Orders(6)"),
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return const Column(
                  children: [
                    OrderWidget(),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 0.8,
                    ),
                  ],
                );
              },
              itemCount: 25,
            ),
          );
  }
}
