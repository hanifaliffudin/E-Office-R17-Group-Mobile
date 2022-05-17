import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Color(0xFF171717),
    backgroundColor: Color(0xFF222831),
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(
      color: Color(0xFF2481CF),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF222831),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF222831),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Color(0xFF222831),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
            color: Colors.white
        )
    ),
    cardTheme: CardTheme(
      color: Color(0xFF222831),
    ),

  );

  static final lightTheme = ThemeData(
    primaryColor: Color(0xFF2481CF),
    scaffoldBackgroundColor: Color(0xFFF8FAFC),
    backgroundColor: Color(0xFFE3E7EF),
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF2481CF),
    ),
    popupMenuTheme: PopupMenuThemeData(
        color: Color(0xFF2481CF)
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF2481CF),
        foregroundColor: Colors.white
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
            color: Colors.black
        )
    ),
  );
}