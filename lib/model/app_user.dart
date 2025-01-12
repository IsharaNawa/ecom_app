import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String? userId, userName, userimage, userEmail;
  Timestamp? createdAt;
  Map? userCart;
  List? userWish, recentlyViewedProducts;

  AppUser();

  AppUser.initAllFields({
    required this.userId,
    required this.userName,
    required this.userimage,
    required this.userEmail,
    required this.createdAt,
    required this.userCart,
    required this.userWish,
    required this.recentlyViewedProducts,
  });
}
