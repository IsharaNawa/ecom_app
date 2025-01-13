import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderProduct with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String productTitle;
  final String userName;
  final String price;
  final String imageUrl;
  final String quantity;
  final Timestamp orderDate;

  OrderProduct(
      {required this.orderId,
      required this.userId,
      required this.productId,
      required this.productTitle,
      required this.userName,
      required this.price,
      required this.imageUrl,
      required this.quantity,
      required this.orderDate});

  factory OrderProduct.fromFirebaseDocumentSnapshot(DocumentSnapshot doc) {
    String orderId = doc.id;
    Map data = doc.data() as Map<String, dynamic>;
    return OrderProduct(
      orderId: orderId,
      userId: data["userId"],
      productId: data["productId"],
      productTitle: data["productTitle"],
      userName: data["userName"],
      price: data["price"].toString(),
      imageUrl: data["imageUrl"],
      quantity: data["quantity"].toString(),
      orderDate: data["orderDate"],
    );
  }
}
