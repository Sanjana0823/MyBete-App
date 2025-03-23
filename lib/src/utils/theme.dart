import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF06333B);
  static const Color onPrimaryColor = Color(0xFFF1FAEE); // Text on primary background
  static const Color secondaryColor = Color(0xFF288994);
  static const Color backgroundColor = Color(0xFF96D8E3);
  static const Color surfaceColor = Color(0xFF35B4C9);
  static const Color errorColor = Color(0xFFE28869);
  static const Color onBackgroundColor = Color(0xFF245D6B); // Text on background

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      onSecondary: Colors.white, // Text on secondary
      background: backgroundColor,
      onBackground: onBackgroundColor,
      surface: surfaceColor,
      onSurface: Colors.black, // Text on surface
      error: errorColor,
      onError: Colors.white, // Text on error
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      onSecondary: Colors.black, // Adjust for dark mode
      background: Color(0xFF06333B), // Dark mode background
      onBackground: Colors.white,
      surface: Color(0xFF245D6B), // Darker surface for contrast
      onSurface: Colors.white,
      error: errorColor,
      onError: Colors.black,
    ),
    useMaterial3: true,
  );
}
