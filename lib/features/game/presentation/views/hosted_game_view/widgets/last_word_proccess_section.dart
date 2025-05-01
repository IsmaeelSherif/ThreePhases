import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';

class LastWordProccessSection extends StatefulWidget {
  const LastWordProccessSection({super.key, required this.updatedGame});

  final GameModel updatedGame;

  @override
  State<LastWordProccessSection> createState() =>
      _LastWordProccessSectionState();
}

class _LastWordProccessSectionState extends State<LastWordProccessSection> {
  bool showWord = false;
  late bool lastWord;
  bool isCanceling = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kButtonBackgroundColorTransparent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "Mark last word as done?",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                showWord = !showWord;
              });
            },
            child: Text(
              !showWord ? "Show Word" : "Hide Word",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 22, 17, 168),
              ),
            ),
          ),
          showWord
              ? Text(
                "${widget.updatedGame.words[widget.updatedGame.lastWordIndex].englishWord} / ${widget.updatedGame.words[widget.updatedGame.lastWordIndex].arabicWord}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
              : SizedBox(),
          const SizedBox(height: 16),
          Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      isCanceling ? AppStrings.canceled : AppStrings.done,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
    ),
    const SizedBox(width: 12),
    Switch(
      value: !isCanceling,
      onChanged: (value) {
    
        _handleConfirmation(value);
      },
      activeColor: AppColors.kGreen,
      inactiveThumbColor: Colors.red,
    ),
  ],
),

        ],
      ),
    );
  }

  void _handleConfirmation(bool value) {
    if (!isCanceling) {
      if (widget.updatedGame.password != null && widget.updatedGame.password!.isNotEmpty) {
        GameConfirmationDialogs.showPasswordConfirmationDialog(
          context: context,
          game: widget.updatedGame,
          title: AppStrings.cancelAddToDoneWord,
          content: AppStrings.cancelAddtoDoneWordsConfirmation,
          onConfirm: () {

            widget.updatedGame.doneWordIndexes.remove(widget.updatedGame.lastWordIndex);
            widget.updatedGame.lastTurnDoneWords.remove(widget.updatedGame.lastWordIndex);
            setState(() {
              isCanceling = !value;
            });
            context.read<GameCubit>().updateGame(
              widget.updatedGame,
            );
          },
        );
      } else {
        GameConfirmationDialogs.showConfirmationDialog(
          context: context,
          game: widget.updatedGame,
          title: AppStrings.cancelAddToDoneWord,
          content: AppStrings.cancelAddtoDoneWordsConfirmation,
          onConfirm: () {
            setState(() {
              isCanceling = !value;
            });
            widget.updatedGame.doneWordIndexes.remove(widget.updatedGame.lastWordIndex);
            widget.updatedGame.lastTurnDoneWords.remove(widget.updatedGame.lastWordIndex);
            context.read<GameCubit>().updateGame(
              widget.updatedGame,
            );
          },
        );
      }
    } else {
      if (widget.updatedGame.password != null && widget.updatedGame.password!.isNotEmpty) {
        GameConfirmationDialogs.showPasswordConfirmationDialog(
          context: context,
          game: widget.updatedGame,
          title: AppStrings.addToDoneWords,
          content: AppStrings.addToDoneWordsConfirmation,
          onConfirm: () {

            widget.updatedGame.doneWordIndexes.add(
              widget.updatedGame.lastWordIndex,
            );
            widget.updatedGame.lastTurnDoneWords.add(
              widget.updatedGame.lastWordIndex,
            );
            lastWord =
                widget.updatedGame.doneWordIndexes.length ==
                widget.updatedGame.wordsCount;
            setState(() {
              isCanceling = !value;
            });
            context.read<GameCubit>().updateGame(
              widget.updatedGame,
            );
          },
        );
      } else {
        GameConfirmationDialogs.showConfirmationDialog(
          context: context,
          game: widget.updatedGame,
          title: AppStrings.addToDoneWords,
          content: AppStrings.addToDoneWordsConfirmation,
          onConfirm: () {
   
            widget.updatedGame.doneWordIndexes.add(
              widget.updatedGame.lastWordIndex,
            );
            widget.updatedGame.lastTurnDoneWords.add(
              widget.updatedGame.lastWordIndex,
            );
            lastWord =
                widget.updatedGame.doneWordIndexes.length ==
                widget.updatedGame.wordsCount;
            setState(() {
              isCanceling = !value;
            });
            context.read<GameCubit>().updateGame(
              widget.updatedGame,
            );
          },
        );
      }
    }
  }
}
