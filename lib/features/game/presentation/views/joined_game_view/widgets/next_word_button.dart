import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';

class NextWordButton extends StatefulWidget {
  final GameModel game;
  const NextWordButton({super.key, required this.game});

  @override
  NextWordButtonState createState() => NextWordButtonState();
}

class NextWordButtonState extends State<NextWordButton> {
  DateTime? _lastPressedTime;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_lastPressedTime != null &&
            DateTime.now().difference(_lastPressedTime!) <
                const Duration(milliseconds: 1500)) {
          return;
        }
        GameConfirmationDialogs.showConfirmationDialog(
          context: context,
          game: widget.game,
          title: AppStrings.nextWord,
          content: AppStrings.nextWordConfirmation,
          onConfirm: () {
            final gameCubit = context.read<GameCubit>();
            gameCubit.nextWord(widget.game);
            _lastPressedTime = DateTime.now();
          },
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        AppStrings.nextWord,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
    );
  }
}
