import 'package:flutter/material.dart';


class AppColors {
   static const kBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff2e003e), // kBackgroundColor
      Color(0xff5d3a9b), // kSecondBackgroundColor
      Color(0xff8a2be2), // kthirdBackgroundColor
    ],
  );
  static const kRainbowTextColors= [  
    Color(0xFFF8BBD0), 
    Color(0xFFE1BEE7), 
    Color(0xFFBBDEFB), 
    Color(0xFFC8E6C9), 
    Color(0xFFFFF9C4), 
    Color(0xFFFFCCBC), 
  ];
  static const kPrimaryTextColor = Colors.white;
  static const kButtonBackgroundColor = Colors.white;
  static const kItemBackgroundColor = Color(0xffFFFFFF);
  static const kRed = Color(0xffDB3022);
  static const kIconColor = Color(0xff9B9B9B);
  static const kSeconderyTextColor = Color(0XFF9B9B9B);
}