import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
var appTheme = ThemeData(
  fontFamily: GoogleFonts.nunitoSans().fontFamily,
  brightness: Brightness.dark,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.black,


  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    bodyMedium: TextStyle(fontWeight: FontWeight.w100, fontSize: 15)
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black87,
    titleTextStyle: GoogleFonts.nunitoSans(
      textStyle: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),

  bottomAppBarTheme: const BottomAppBarTheme(
    color : Colors.black87,
  ),
);


