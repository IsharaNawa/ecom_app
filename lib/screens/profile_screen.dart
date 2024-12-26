import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/services/app_functions.dart';

import 'package:ecom_app/screens/auth_screens/login_screen.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:ecom_app/widgets/app_title.dart';
import 'package:ecom_app/widgets/profile_screen_widgets/profile_screen_general_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkmodeOn = ref.watch(darkModeThemeStatusProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Icon(
            IconManager.appBarIcon,
          ),
        ),
        title: const AppTitle(
          fontSize: 24.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Visibility(
              visible: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12,
                ),
                child: Text(
                  "Please log in to gain full access",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      "https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_640.png",
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ishara Nawarathna",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "yc.ishara@gmail.com",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.start,
                      )
                    ],
                  )
                ],
              ),
            ),
            const ProfileScreenGeneralSection(),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SwitchListTile(
              secondary: isDarkmodeOn
                  ? Icon(IconManager.darkModeIcon)
                  : Icon(IconManager.lightModeIcon),
              title: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Dark Mode"),
              ),
              subtitle: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Turn on/off dark mode"),
              ),
              value: isDarkmodeOn,
              onChanged: (value) {
                ref.read(darkModeThemeStatusProvider.notifier).toggleDarkMode();
              },
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              thickness: 0.8,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Text(
                "Others",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ListTile(
              leading: Icon(IconManager.privacyPolicyIcon),
              title: const Text("Privacy Policy"),
              trailing: const Icon(Icons.arrow_right),
            ),
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: TextButton.icon(
                    onPressed: () async {
                      await AppFunctions.showErrorOrWarningOrImagePickerDialog(
                        context: context,
                        isWarning: true,
                        mainTitle: "Do you want to Log out?",
                        icon: Icon(IconManager.generalLogoutIcon),
                        action1Text: "No",
                        action2Text: "Yes",
                        action1Func: () {
                          Navigator.of(context).pop();
                        },
                        action2Func: () async {
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        isDarkmodeOn: isDarkmodeOn,
                      );
                    },
                    label: const Text("Log Out"),
                    icon: Icon(IconManager.generalLogoutIcon),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
