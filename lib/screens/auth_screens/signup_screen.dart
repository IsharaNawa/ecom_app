import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/screens/auth_screens/login_screen.dart';
import 'package:ecom_app/screens/root_screen.dart';
import 'package:ecom_app/widgets/app_title.dart';
import 'package:ecom_app/widgets/auth_screen_widgets/form_fields.dart';
import 'package:ecom_app/widgets/auth_screen_widgets/profile_image_picker.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _email;
  String? _password;
  String? _confirmPassword;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final OutlineInputBorder outlinedInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(
          10,
        ),
      ),
      borderSide: BorderSide(
        width: 1.5,
        color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
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
                        borderColor: themeProvider.getIsDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: CustomFormField(
                          outlinedInputBorder: outlinedInputBorder,
                          inputLabel: "Username",
                          nullValueErrorStringValidator:
                              "Please enter a valid Username!",
                          validatorErrorString:
                              "Please enter a valid Username!",
                          onSavedFunction: (value) {
                            _userName = value;
                          },
                          formFieldType: FormFieldType.username,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: CustomFormField(
                          outlinedInputBorder: outlinedInputBorder,
                          inputLabel: "Email",
                          nullValueErrorStringValidator:
                              "Please enter a valid Email!",
                          validatorErrorString: "Please enter a valid email!",
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
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: PasswordFormField(
                          outlinedInputBorder: outlinedInputBorder,
                          inputLabel: "Confirm Password",
                          nullValueErrorStringValidator:
                              "Please enter a valid Password!",
                          validatorErrorString:
                              "Password should be at least 8 Characters!",
                          onSavedFunction: (value) {
                            _confirmPassword = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              return;
                            }

                            _formKey.currentState!.save();

                            if (_userName == null ||
                                _email == null ||
                                _password == null ||
                                _confirmPassword == null) {
                              return;
                            }

                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RootScreen(),
                              ),
                            );
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
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              indent: 25,
                              endIndent: 10,
                              thickness: 0.5,
                              color: themeProvider.getIsDarkTheme
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
                              color: themeProvider.getIsDarkTheme
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
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RootScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: BorderSide(
                            width: 1.0,
                            color: themeProvider.getIsDarkTheme
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
                            "Already have an Account?",
                            style: GoogleFonts.oxygen(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
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
      ),
    );
  }
}