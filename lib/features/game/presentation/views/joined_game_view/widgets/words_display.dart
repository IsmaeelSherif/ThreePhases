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
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.kTransparentWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            word != null
                ? "${word.englishWord} / ${word.arabicWord}"
                : '',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 32,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
