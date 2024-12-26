import 'package:riverpod/riverpod.dart';

class DarkModeThemeStatusNotifier extends StateNotifier<bool> {
  DarkModeThemeStatusNotifier() : super(false);

  void toggleDarkMode() {
    state = !state;
  }
}

final darkModeThemeStatusProvider =
    StateNotifierProvider<DarkModeThemeStatusNotifier, bool>((ref) {
  return DarkModeThemeStatusNotifier();
});
