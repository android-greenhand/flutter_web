import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
    ),
  );
} 