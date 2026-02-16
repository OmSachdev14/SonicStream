import 'package:flutter/material.dart';
import 'package:spotufy/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border() => OutlineInputBorder(
        borderSide: const BorderSide(color: Pallete.borderColor, width: 3),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    inputDecorationTheme:InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27 ),
      enabledBorder: _border(),
      focusedBorder: _border().copyWith(borderSide: const BorderSide(color: Pallete.gradient2,width: 3))
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Pallete.backgroundColor)
  );
}
