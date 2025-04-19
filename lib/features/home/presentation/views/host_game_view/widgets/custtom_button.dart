import 'package:flutter/material.dart';
import 'package:three_phases/core/utils/app_colors.dart';

class CusttomButton extends StatelessWidget {
  const CusttomButton({super.key, required this.text, required this.onPressed, required this.isSelected});

  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected ? AppColors.kPrimaryColor : AppColors.kSeconderyTextColor,
                  foregroundColor: isSelected ? AppColors.kPrimaryColor : AppColors.kSeconderyTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    
                  ),
                ),
          child:  Text(text,style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),),
        );
  }
}