import 'package:flutter/material.dart';
import 'package:three_phases/core/utils/app_colors.dart';

class CusttomTurnButton extends StatelessWidget {
  const CusttomTurnButton({
    super.key,
    required this.onPressed,
    required this.text,
  });
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kGreen,
        foregroundColor: AppColors.kWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontSize: 25),
      ),
    );
  }
}
