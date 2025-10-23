import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get lightTheme {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );
    return base.copyWith(
      textTheme: GoogleFonts.promptTextTheme(base.textTheme),
    );
  }

  ThemeData get darkTheme {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
    return base.copyWith(
      textTheme: GoogleFonts.promptTextTheme(base.textTheme),
    );
  }

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
