import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isDarkMode) {
    themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    fontFamily: 'Merriweather',
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
    colorScheme: const ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    fontFamily: 'Merriweather',
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.red.shade200, opacity: 0.8),
    colorScheme: const ColorScheme.light(),
  );
}