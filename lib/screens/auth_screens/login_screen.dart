import 'package:ecom_app/services/app_functions.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/auth_screen_widgets/dark_mode_toggler.dart';
import 'package:ecom_app/screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/screens/auth_screens/forgot_password_screen.dart';
import 'package:ecom_app/screens/auth_screens/signup_screen.dart';
import 'package:ecom_app/screens/root_screen.dart';
import 'package:ecom_app/widgets/app_title.dart';
import 'package:ecom_app/widgets/auth_screen_widgets/app_form_field.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

      await AppFunctions.triggerToast("You are Logged In!", ref);

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
            ref: ref,
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
            ref: ref,
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

    try {
      setState(() {
        isLoading = true;
      });

      await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await AppFunctions.triggerToast("You are Logged In!", ref);

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
                            child: AppFormField(
                              outlinedInputBorder: outlinedInputBorder,
                              inputLabel: "Email",
                              nullValueErrorStringValidator:
                                  "Please enter a valid Email!",
                              formFieldType: FormFieldType.email,
                              controller: _emailController,
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
                              _googleSignIn(context, isDarkmodeOn);
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
                                          const SignupScreen(),
                                    ),
                                  );
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
            const DarkModeToggler(),
          ],
        ),
      ),
    );
  }
}
