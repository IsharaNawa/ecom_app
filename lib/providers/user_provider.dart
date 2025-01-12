import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<AppUser> {
  UserNotifier() : super(AppUser());

  Future<AppUser?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      return null;
    }

    String uid = user.uid;
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      final userMap = userDoc.data() as Map<String, dynamic>;

      state = AppUser.initAllFields(
        userId: userMap["userId"],
        userName: userMap["userName"],
        userimage: userMap["userImage"],
        userEmail: userMap["userEmail"],
        createdAt: userMap["createdAt"],
        userCart: userMap["userCart"],
        userWish: userMap["useruserWishListId"],
      );

      return state;
    } on FirebaseException catch (error) {
      print(error);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AppUser>((ref) {
  return UserNotifier();
});
