import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:three_phases/core/utils/app_colors.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
  Color backgroundColor =  AppColors.kRed,
}) {
 Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0,
        
    );
}
