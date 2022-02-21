import 'package:flutter/material.dart';

import './storage.dart' as storage;

class ThemeNotifier with ChangeNotifier {
  /*ColorScheme(
      primary: primarySwatch,
      primaryVariant: primaryColorDark ?? (isDark ? Colors.black : primarySwatch[700]!),
      secondary: secondary,
      secondaryVariant: isDark ? Colors.tealAccent[700]! : primarySwatch[700]!,
      surface: cardColor ?? (isDark ? Colors.grey[800]! : Colors.white),
      background: backgroundColor ?? (isDark ? Colors.grey[700]! : primarySwatch[200]!),
      error: errorColor ?? Colors.red[700]!,
      onPrimary: primaryIsDark ? Colors.white : Colors.black,
      onSecondary: secondaryIsDark ? Colors.white : Colors.black,
      onSurface: isDark ? Colors.white : Colors.black,
      onBackground: primaryIsDark ? Colors.white : Colors.black,
      onError: isDark ? Colors.black : Colors.white,
      brightness: brightness,
    );*/
  static final lightTheme = ThemeData(
    primarySwatch: Colors.orange,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.orange,
    ),
  );

  static final darkTheme = ThemeData(
    primarySwatch: Colors.orange,
    toggleableActiveColor: Colors.orange[600],
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.orange,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: Colors.orange[700],
    ),
  );

  ThemeMode themeMode = ThemeMode.system;

  bool get isDark => themeMode == ThemeMode.dark;

  bool get isSystem => themeMode == ThemeMode.system;

  ThemeNotifier() {
    storage.darkTheme.get().then((value) {
      if (value != null) {
        themeMode = value ? ThemeMode.dark : ThemeMode.light;
        notifyListeners();
      }
    });
  }

  void setDarkMode() async {
    themeMode = ThemeMode.dark;
    storage.darkTheme.set(true);
    notifyListeners();
  }

  void setLightMode() async {
    themeMode = ThemeMode.light;
    storage.darkTheme.set(false);
    notifyListeners();
  }

  void setSystemTheme() async {
    themeMode = ThemeMode.system;
    storage.darkTheme.set(null);
    notifyListeners();
  }

  bool get isEffectivelyDark =>
      themeMode == ThemeMode.dark ||
      WidgetsBinding.instance!.platformDispatcher.platformBrightness == Brightness.dark;
}
