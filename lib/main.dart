import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/font_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/font_list_screen.dart';

void main() {
  runApp(const FontNotesApp());
}

class FontNotesApp extends StatelessWidget {
  const FontNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FontProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, theme, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Font Notes',
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const FontListScreen(),
          );
        },
      ),
    );
  }
}
