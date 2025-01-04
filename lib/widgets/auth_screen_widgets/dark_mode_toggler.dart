import 'package:ecom_app/providers/theme_provider.dart';
import 'package:ecom_app/services/icon_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DarkModeToggler extends ConsumerWidget {
  const DarkModeToggler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      right: 10,
      top: 20,
      child: IconButton(
        icon: ref.watch(darkModeThemeStatusProvider)
            ? Icon(IconManager.darkModeIcon)
            : Icon(IconManager.lightModeIcon),
        onPressed: () {
          ref.read(darkModeThemeStatusProvider.notifier).toggleDarkMode();
        },
      ),
    );
  }
}
