import 'package:flutter/material.dart';
import 'package:three_phases/core/utils/app_colors.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
  Color backgroundColor =  AppColors.kRed,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ),
  );
}
