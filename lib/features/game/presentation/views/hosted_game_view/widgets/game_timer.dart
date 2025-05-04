import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';

class GameTimer extends StatelessWidget {
  const GameTimer({super.key, required this.game});
  final GameModel game;

  void _handleEditTime(BuildContext context) {
    GameConfirmationDialogs.showEditTurnTimeDialog(
      context: context,
      game: game,
     gameCubit: context.read<GameCubit>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.turnTime,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
        ),
        const SizedBox(width: 4),
        Text(
                " ${game.turnTime.toString()} Sec",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
              ),
        const SizedBox(width: 12),
        IconButton(
          icon: Icon(
             Icons.edit,
            color: Colors.white,
          ),
          onPressed: () => _handleEditTime(context),
        ),
      ],
    );
  }
}
