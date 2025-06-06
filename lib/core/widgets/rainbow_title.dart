import 'package:flutter/material.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';

class RainbowTitle extends StatelessWidget {
  const RainbowTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRainbowText(
                context,
                AppStrings.appTitle
              ),
              
            ],
          ),
    );
     
  }

  Widget _buildRainbowText(BuildContext context, String text) {
    const List<Color> pastelColors = AppColors.kRainbowTextColors;

    final baseStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontStyle: FontStyle.italic, // Make it italic
    );

    if (baseStyle == null) {
      // Fallback if the theme style is somehow null
      return Text(
        text,
        style: const TextStyle(fontSize: 40, fontStyle: FontStyle.italic),
      );
    }

    List<TextSpan> spans = [];
    for (int i = 0; i < text.length; i++) {
      spans.add(
        TextSpan(
          text: text[i], // Add one character at a time
          style: baseStyle.copyWith(
            color:
                pastelColors[i % pastelColors.length], // Cycle through colors
          ),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(text: TextSpan(children: spans)));
  }
}
