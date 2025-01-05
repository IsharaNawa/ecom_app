import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/widgets/auth_screen_widgets/dark_mode_toggler.dart';
import 'package:ecom_app/screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/screens/auth_screens/login_screen.dart';
import 'package:ecom_app/screens/root_screen.dart';
import 'package:ecom_app/widgets/app_title.dart';
import 'package:ecom_app/widgets/auth_screen_widgets/app_form_field.dart';
import 'package:ecom_app/widgets/auth_screen_widgets/profile_image_picker.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();

  File? pickedImage;

  Future<void> _signIn(bool isDarkmodeOn) async {
    if (!_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      return;
    }

    if (pickedImage == null) {
      AppFunctions.showErrorOrWarningOrImagePickerDialog(
        context: context,
        isWarning: false,
        mainTitle: "Please select a profile picture!",
        icon: Icon(IconManager.imagepickingErrorIcon),
        action1Text: "OK",
        action2Text: "",
        action1Func: () async {
          Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
        },
        action2Func: () {},
        ref: ref,
      );
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        isLoading = true;
      });

      await auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final User? user = auth.currentUser;

      if (user == null) {
        throw Exception("Error! User is not valid!");
      }

      final String uid = user.uid;

      final firebaseRef =
          FirebaseStorage.instance.ref().child("usersImage").child("$uid.jpg");

      await firebaseRef.putFile(pickedImage!);

      String imageUrl = await firebaseRef.getDownloadURL();

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "userId": uid,
        "userName": _userNameController.text.trim(),
        "userImage": imageUrl,
        "userEmail": _emailController.text.trim(),
        "createdAt": Timestamp.now(),
        "userCart": [],
        "userWishList": [],
      });

      await AppFunctions.triggerToast("Your account is created!", ref);

      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RootScreen(),
        ),
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;
      AppFunctions.triggerErrorDialog(
        context: context,
        ref: ref,
        errorMessage: error.message.toString(),
      );
    } catch (error) {
      if (!mounted) return;
      AppFunctions.triggerErrorDialog(
        context: context,
        ref: ref,
        errorMessage: error.toString(),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkmodeOn = ref.watch(darkModeThemeStatusProvider);

    final OutlineInputBorder outlinedInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(
          10,
        ),
      ),
      borderSide: BorderSide(
        width: 1.5,
        color: isDarkmodeOn ? Colors.white : Colors.black,
      ),
    );

    if (isLoading) {
      return const LoadingScreen(
        isIncludeAppTitle: true,
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppTitle(
                      fontSize: 30.0,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Hello There!",
                      style: GoogleFonts.oxygen(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Create an account to experience one of the best online shopping experiences ever!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oxygen(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ProfileImagePicker(
                            borderColor:
                                isDarkmodeOn ? Colors.white : Colors.black,
                            pickedImageFileGetter: (File? file) {
                              pickedImage = file;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: AppFormField(
                              outlinedInputBorder: outlinedInputBorder,
                              inputLabel: "FirstName LastName",
                              nullValueErrorStringValidator:
                                  "Please enter your full name!",
                              controller: _userNameController,
                              formFieldType: FormFieldType.fullname,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: AppFormField(
                              outlinedInputBorder: outlinedInputBorder,
                              inputLabel: "Email",
                              nullValueErrorStringValidator:
                                  "Please enter a valid Email!",
                              controller: _emailController,
                              formFieldType: FormFieldType.email,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: AppFormField(
                              outlinedInputBorder: outlinedInputBorder,
                              inputLabel: "Password",
                              nullValueErrorStringValidator:
                                  "Please enter a valid Password!",
                              controller: _passwordController,
                              formFieldType: FormFieldType.password,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: AppFormField(
                              outlinedInputBorder: outlinedInputBorder,
                              inputLabel: "Confirm Password",
                              nullValueErrorStringValidator:
                                  "Please enter a valid Password!",
                              controller: _confirmedPasswordController,
                              formFieldType: FormFieldType.confirmPassword,
                              comparisonValue: _passwordController.text,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _signIn(isDarkmodeOn);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                              ),
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  indent: 25,
                                  endIndent: 10,
                                  thickness: 0.5,
                                ),
                              ),
                              Text(
                                "OR",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  indent: 10,
                                  endIndent: 25,
                                  thickness: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          IconButton(
                            onPressed: () async {
                              await Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const RootScreen(),
                                ),
                              );
                            },
                            style: Theme.of(context).outlinedButtonTheme.style,
                            icon: Image.asset(
                              "assets/images/google_logo.png",
                              height: 40,
                              width: 40,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an Account?",
                                style: GoogleFonts.oxygen(
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Log In.",
                                  style: GoogleFonts.oxygen(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const DarkModeToggler(),
          ],
        ),
      ),
    );
  }
}
