import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/screens/root_screen.dart';
import 'package:ecom_app/widgets/app_title.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _isPWVisible = false;

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
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return "Please enter a valid Email!";
                            }

                            if (!EmailValidator.validate(value)) {
                              return "Please enter a valid Email!";
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _email = value;
                          },
                          autocorrect: false,
                          decoration: InputDecoration(
                            enabledBorder: outlinedInputBorder,
                            focusedBorder: outlinedInputBorder,
                            errorBorder: outlinedInputBorder,
                            focusedErrorBorder: outlinedInputBorder,
                            label: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                              ),
                              child: Text(
                                "Email",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return "Please enter a valid Password!";
                            }

                            if (value.length < 8) {
                              return "Please enter a valid Password with 8 or more Characters!";
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _password = value;
                          },
                          autocorrect: false,
                          obscureText: !_isPWVisible,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                print("pressed");
                                setState(() {
                                  _isPWVisible = !_isPWVisible;
                                });
                              },
                              child: _isPWVisible
                                  ? const Icon(HugeIcons.strokeRoundedView)
                                  : const Icon(
                                      HugeIcons.strokeRoundedViewOffSlash),
                            ),
                            enabledBorder: outlinedInputBorder,
                            focusedBorder: outlinedInputBorder,
                            errorBorder: outlinedInputBorder,
                            focusedErrorBorder: outlinedInputBorder,
                            label: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                              ),
                              child: Text(
                                "Password",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.oxygen(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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

                            if (_email == null || _password == null) {
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
                        onPressed: () {},
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
                            "Don't have an Account?",
                            style: GoogleFonts.oxygen(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Sign up",
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
