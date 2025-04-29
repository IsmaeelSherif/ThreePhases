import 'package:flutter/material.dart';
import 'package:three_phases/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.kPrimaryTextColor),
      titleTextStyle: TextStyle(
        color: AppColors.kPrimaryTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.kPrimaryTextColor,
        fontSize: 60,
      ),
      bodyLarge: TextStyle(
        color: AppColors.kPrimaryTextColor,
        fontSize: 25  ,
      ),
      bodyMedium: TextStyle(
        color: AppColors.kSeconderyTextColor,
        fontSize: 14,
      ),

    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kButtonBackgroundColorTransparent,
        foregroundColor: AppColors.kWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
