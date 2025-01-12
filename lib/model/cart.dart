import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/model/product.dart';

class Cart {
  Cart(
      {required this.cartId,
      required this.product,
      required this.quantity,
      required this.createdAt});

  final String cartId;
  final Product product;
  final int quantity;
  final Timestamp createdAt;

  set quantity(int value) {
    quantity = value;
  }
}
