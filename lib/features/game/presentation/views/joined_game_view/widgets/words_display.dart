import 'package:flutter/material.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_colors.dart';

class WordDisplay extends StatelessWidget {
  final GameModel game;

  const WordDisplay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final index = game.lastWordIndex;
    final word = (index != -1) ? game.words[index] : null;

    return Container(
      width: double.infinity,
     
     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.kButtonBackgroundColorTransparent,
          border: Border.all(color: AppColors.kWhite),
        ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          word != null
              ? "${word.englishWord}  ${word.arabicWord.isNotEmpty ? " / ${word.arabicWord}" : ""}"
              : '',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
