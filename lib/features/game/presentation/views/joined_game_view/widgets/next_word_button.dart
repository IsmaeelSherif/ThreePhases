import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';
import 'package:three_phases/features/game/presentation/views/joined_game_view/widgets/custom_turn_button.dart';

class NextWordButton extends StatefulWidget {
  final GameModel game;
  const NextWordButton({super.key, required this.game});

  @override
  NextWordButtonState createState() => NextWordButtonState();
}

class NextWordButtonState extends State<NextWordButton> {
    final _audioPlayer = AudioPlayer();
  void _playSound(){
       _audioPlayer.play(AssetSource('rings/done_word.ogg'));
  }
  DateTime? _lastPressedTime;
  @override
  Widget build(BuildContext context) {
    return CustomTurnButton(
      onPressed: () {
        if (_lastPressedTime != null &&
            DateTime.now().difference(_lastPressedTime!) <
                const Duration(milliseconds: 1500)) {
          return;
        }
         final gameCubit = context.read<GameCubit>();
         gameCubit.isDialogOpen=true;
        GameConfirmationDialogs.showConfirmationDialog(
          context: context,
          game: widget.game,
          title: AppStrings.nextWord,
          content: AppStrings.nextWordConfirmation,
          onConfirm: () {
            final gameCubit = context.read<GameCubit>();
            gameCubit.nextWord(widget.game);
            _lastPressedTime = DateTime.now();
            gameCubit.isDialogOpen = false;
            _playSound();
          },
          onCancel: () {
            gameCubit.isDialogOpen = false;
          },
        );
      },
      text: AppStrings.nextWord,

    );
  }
}
