import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var appTheme = ThemeData(
  fontFamily: GoogleFonts.nunitoSans().fontFamily,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF64B5F6), // Soft blue
  scaffoldBackgroundColor: const Color(0xFF121212), // Dark grey

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Color(0xFFBB86FC), // Light purple
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    bodyMedium: TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.w300,
      fontSize: 15,
    ),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF1F1F1F),
    elevation: 0,
    titleTextStyle: GoogleFonts.nunitoSans(
      textStyle: const TextStyle(
        color: Color(0xFFBB86FC),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),

  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color(0xFF1F1F1F),
  ),
);
