import 'package:flutter/material.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/features/home/presentation/views/home_view/widgets/play_buttons.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    return  GradientScaffold(
      appBar: AppBar(
            backgroundColor: Colors.transparent, // Make AppBar transparent
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.language, color: Colors.white),
                tooltip: 'Change Language', // Optional tooltip
                onPressed: () {
                  // Toggle logic
                
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: height *0.05),
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRainbowText(context, AppStrings.appTitle.split(' ')[0]),
                    _buildRainbowText(context, AppStrings.appTitle.split(' ')[1]),
                  ],
                ),
                SizedBox(height: height *0.15,),
                PlayButtons()
              ]
            ),
          ),);
  }

  Widget _buildRainbowText(BuildContext context, String text) {
    final List<Color> pastelColors = AppColors.kRainbowTextColors;

    final baseStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontStyle: FontStyle.italic, // Make it italic
        );

    if (baseStyle == null) {
      // Fallback if the theme style is somehow null
      return Text(text, style: const TextStyle(fontSize: 40, fontStyle: FontStyle.italic));
    }

    List<TextSpan> spans = [];
    for (int i = 0; i < text.length; i++) {
      spans.add(
        TextSpan(
          text: text[i], // Add one character at a time
          style: baseStyle.copyWith(
            color: pastelColors[i % pastelColors.length], // Cycle through colors
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}

