import 'package:ecom_app/constants/app_colors.dart';
import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/screens/auth_screens/forgot_password_screen.dart';
import 'package:ecom_app/screens/auth_screens/signup_screen.dart';
import 'package:ecom_app/screens/root_screen.dart';
import 'package:ecom_app/widgets/app_title.dart';
import 'package:ecom_app/widgets/auth_screen_widgets/form_fields.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  String? _email;
  String? _password;

  Future<void> _googleSignIn(BuildContext context, bool isDarkmodeOn) async {
    try {
      setState(() {
        isLoading = true;
      });
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;

        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResults = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
        } else {
          throw Exception("Error while collecting google auth credentials!");
        }
      }

      await Fluttertoast.showToast(
        msg: "Your are Logged In!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: isDarkmodeOn
            ? AppColors.lightScaffoldColor
            : AppColors.darkScaffoldColor,
        textColor: isDarkmodeOn
            ? AppColors.darkScaffoldColor
            : AppColors.lightScaffoldColor,
        fontSize: 16.0,
      );

      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RootScreen(),
          ),
        );
      });
    } on FirebaseException catch (error) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timestamp) {
          AppFunctions.showErrorOrWarningOrImagePickerDialog(
            context: context,
            isWarning: false,
            mainTitle: error.message.toString(),
            icon: Icon(IconManager.accountErrorIcon),
            action1Text: "OK",
            action2Text: "",
            action1Func: () async {
              Navigator.of(context).canPop()
                  ? Navigator.of(context).pop()
                  : null;
            },
            action2Func: () {},
            isDarkmodeOn: isDarkmodeOn,
          );
        },
      );
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timestamp) {
          AppFunctions.showErrorOrWarningOrImagePickerDialog(
            context: context,
            isWarning: false,
            mainTitle: error.toString(),
            icon: Icon(IconManager.accountErrorIcon),
            action1Text: "OK",
            action2Text: "",
            action1Func: () async {
              Navigator.of(context).canPop()
                  ? Navigator.of(context).pop()
                  : null;
            },
            action2Func: () {},
            isDarkmodeOn: isDarkmodeOn,
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logIn(bool isDarkmodeOn) async {
    if (!_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      return;
    }

    _formKey.currentState!.save();

    if (_email == null || _password == null) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await auth.signInWithEmailAndPassword(
        email: _email!.trim(),
        password: _password!.trim(),
      );

      await Fluttertoast.showToast(
        msg: "Your are Logged In!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: isDarkmodeOn
            ? AppColors.lightScaffoldColor
            : AppColors.darkScaffoldColor,
        textColor: isDarkmodeOn
            ? AppColors.darkScaffoldColor
            : AppColors.lightScaffoldColor,
        fontSize: 16.0,
      );

      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RootScreen(),
        ),
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;
      await AppFunctions.showErrorOrWarningOrImagePickerDialog(
        context: context,
        isWarning: false,
        mainTitle: error.message.toString(),
        icon: Icon(IconManager.accountErrorIcon),
        action1Text: "OK",
        action2Text: "",
        action1Func: () async {
          Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
        },
        action2Func: () {},
        isDarkmodeOn: isDarkmodeOn,
      );
    } catch (error) {
      if (!mounted) return;
      await AppFunctions.showErrorOrWarningOrImagePickerDialog(
        context: context,
        isWarning: false,
        mainTitle: error.toString(),
        icon: Icon(IconManager.accountErrorIcon),
        action1Text: "OK",
        action2Text: "",
        action1Func: () async {
          Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
        },
        action2Func: () {},
        isDarkmodeOn: isDarkmodeOn,
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTitle(
                      fontSize: 30.0,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              )
            : Center(
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
                        "Welcome Back!",
                        style: GoogleFonts.oxygen(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: CustomFormField(
                                outlinedInputBorder: outlinedInputBorder,
                                inputLabel: "Email",
                                nullValueErrorStringValidator:
                                    "Please enter a valid Email!",
                                validatorErrorString:
                                    "Please enter a valid email!",
                                onSavedFunction: (value) {
                                  _email = value;
                                },
                                formFieldType: FormFieldType.email,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: PasswordFormField(
                                outlinedInputBorder: outlinedInputBorder,
                                inputLabel: "Password",
                                nullValueErrorStringValidator:
                                    "Please enter a valid Password!",
                                validatorErrorString:
                                    "Password should be at least 8 Characters!",
                                onSavedFunction: (value) {
                                  _password = value;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: GoogleFonts.oxygen(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 60,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _logIn(isDarkmodeOn);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                ),
                                child: Text(
                                  "Log In",
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
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    indent: 25,
                                    endIndent: 10,
                                    thickness: 0.5,
                                    color: isDarkmodeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const Text(
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
                                    color: isDarkmodeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            IconButton(
                              onPressed: () async {
                                _googleSignIn(context, isDarkmodeOn);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                side: BorderSide(
                                  width: 1.0,
                                  color: isDarkmodeOn
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
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
                                  "Don't have an Account?",
                                  style: GoogleFonts.oxygen(
                                    fontSize: 18,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen()));
                                  },
                                  child: Text(
                                    "Sign Up.",
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
      ),
    );
  }
}
