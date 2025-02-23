import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/model/order.dart';
import 'package:ecom_app/providers/order_provider.dart';
import 'package:ecom_app/providers/user_provider.dart';
import 'package:ecom_app/screens/generic_screens/error_screen.dart';
import 'package:ecom_app/screens/generic_screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/screens/generic_screens/empty_bag_screen.dart';
import 'package:ecom_app/widgets/orders_screen_widgets/order_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const ErrorScreen(
        errorTitle: "No Authenticated User Found!",
      );
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders").snapshots(),
        builder: (context, snapshot) {
          List<OrderProduct> ordersList = [];
          print("len");
          print(ref.read(orderProvider).length);
          ref.watch(orderProvider.notifier).fetchOrders(context, ref);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(
              loadingText: "Loading your orders...",
            );
          }

          if (snapshot.hasError) {
            return ErrorScreen(errorTitle: snapshot.error.toString());
          }

          if (snapshot.data == null ||
              !snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return EmptyBagScreen(
              mainImage: Icon(
                IconManager.emptyOrdersListIcon,
                size: 200,
              ),
              mainTitle: "There are no ongoing orders!",
              subTitle:
                  "You dont have any ongoing orders. When you purchase some products, they will appear here.",
              buttonText: "Explore Products",
              buttonFunction: () {},
            );
          }

          String? userId = ref.read(userProvider).userId;

          if (userId == null) {
            return const ErrorScreen(errorTitle: "Your userId is null!");
          }

          for (var element in snapshot.data!.docs) {
            Map<String, dynamic> orderData = element.data();

            if (userId != orderData["userId"]) {
              continue;
            }

            ordersList.add(OrderProduct.fromFirebaseDocumentSnapshot(element));
          }

          ordersList.sort((a, b) {
            return b.orderDate.compareTo(a.orderDate);
          });

          if (ordersList.isEmpty) {
            return EmptyBagScreen(
              mainImage: Icon(
                IconManager.emptyOrdersListIcon,
                size: 200,
              ),
              mainTitle: "There are no ongoing orders!",
              subTitle:
                  "You dont have any ongoing orders. When you purchase some products, they will appear here.",
              buttonText: "Explore Products",
              buttonFunction: () {},
            );
          }

          return Scaffold(
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
              title: Text("Orders(${ordersList.length.toString()})"),
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    OrderWidget(
                      orderProduct: ordersList[index],
                    ),
                    const Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 0.8,
                    ),
                  ],
                );
              },
              itemCount: ordersList.length,
            ),
          );
        });
  }
}
