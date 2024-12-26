import 'dart:io';

import 'package:ecom_app/model/category.dart';

class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.image,
    required this.category,
  });

  final String id, title, description;
  final double price;
  final int quantity;
  final File image;
  final Category category;
}
