import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';
import 'package:three_phases/features/game/presentation/views/joined_game_view/widgets/custom_turn_button.dart';
import 'package:three_phases/features/game/presentation/views/joined_game_view/widgets/next_word_button.dart';
import 'package:three_phases/features/game/presentation/views/joined_game_view/widgets/turn_time_for_player_section.dart';
import 'package:three_phases/features/game/presentation/views/joined_game_view/widgets/words_display.dart';

class GameSection extends StatelessWidget {
  const GameSection({super.key, required this.updatedGame});

  final GameModel updatedGame;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final gameCubit = context.read<GameCubit>();
    final game = updatedGame;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Text(
          '${AppStrings.wordsDone}: ${game.doneWordIndexes.length}/${game.wordsCount}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 22, color: Colors.white),
        ),
         SizedBox(height: height * .22),
        BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
             if (!game.turnAvailable && gameCubit.isDialogOpen){
                Navigator.pop(context);
             }
            return Column(
              children: [
                if (!game.turnAvailable)
                  Text(
                    AppStrings.waitingForHost,
                    style: const TextStyle(fontSize: 18),
                  )
                else if (!gameCubit.isTurnStarted)
                  CustomTurnButton(
                    onPressed: () {
                      GameConfirmationDialogs.showConfirmationDialog(
                        context: context,
                        title: AppStrings.startTurn,
                        content: AppStrings.startTurnConfirmation,
                        game: game,
                        onConfirm: () => gameCubit.startTurn(game),
                      );
                    },
                    text: AppStrings.startTurn,
                  )
                else
                  Column(
                    children: [
                      TurnTimer(game: game),
                      const SizedBox(height: 32),
                      WordDisplay(game: game),
                      const SizedBox(height: 16),
                      NextWordButton(game: game),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
