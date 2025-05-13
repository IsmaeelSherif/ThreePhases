import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';

// ignore: must_be_immutable
class LastWordProccessSection extends StatelessWidget {
   LastWordProccessSection({super.key, required this.updatedGame});

  final GameModel updatedGame;

  bool showWord = false;

  late bool lastWord;

  late bool isCanceling;

  @override
  Widget build(BuildContext context) {
        isCanceling = !updatedGame.doneWordIndexes.contains(updatedGame.lastWordIndex);

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
        // ShowWord(updatedGame: updatedGame),
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
    
        _handleConfirmation(value, context);
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

  void _handleConfirmation(bool value, BuildContext context) async{
      String word= "${updatedGame.words[updatedGame.lastWordIndex].englishWord} / ${updatedGame.words[updatedGame.lastWordIndex].arabicWord}";
    if (!isCanceling) {
      if (updatedGame.password != null && updatedGame.password!.isNotEmpty) {
       final bool result= await GameConfirmationDialogs.showPasswordConfirmationDialog(
          context: context,
          game: updatedGame,
          title: AppStrings.cancelAddToDoneWord,
          content: AppStrings.cancelAddtoDoneWordsConfirmation,
          onConfirm: () {
           
          },
          gameCubit: context.read<GameCubit>(),
          remove: true,
        );
        if(result){
        
        }
      } else {
        GameConfirmationDialogs.showConfirmationDialog(
          context: context,
          game: updatedGame,
          title: AppStrings.cancelAddToDoneWord,
          content: AppStrings.cancelAddtoDoneWordsConfirmation,
          onConfirm: () {
            updatedGame.doneWordIndexes.remove(updatedGame.lastWordIndex);
            updatedGame.lastTurnDoneWords.remove(updatedGame.lastWordIndex);
            context.read<GameCubit>().updateGame(
              updatedGame,
            );
            showSnackBar(context, message: "$word has been removed from done words",backgroundColor: AppColors.kGreen);
          },
        );
      }
    } else {
      if (updatedGame.password != null && updatedGame.password!.isNotEmpty) {
       final bool result= await GameConfirmationDialogs.showPasswordConfirmationDialog(
          context: context,
          game: updatedGame,
          title: AppStrings.addToDoneWords,
          content: AppStrings.addToDoneWordsConfirmation,
          onConfirm: () { 
          
          },
          gameCubit: context.read<GameCubit>(),
          remove: false,
        );
        if(result){
          
        }
      } else {
        GameConfirmationDialogs.showConfirmationDialog(
          context: context,
          game: updatedGame,
          title: AppStrings.addToDoneWords,
          content: AppStrings.addToDoneWordsConfirmation,
          onConfirm: () {
   
            updatedGame.doneWordIndexes.add(
              updatedGame.lastWordIndex,
            );
            updatedGame.lastTurnDoneWords.add(
              updatedGame.lastWordIndex,
            );
            lastWord =
                updatedGame.doneWordIndexes.length ==
                updatedGame.wordsCount;
            context.read<GameCubit>().updateGame(
              updatedGame,
            );
      showSnackBar(context, message: "$word has been added to done words",backgroundColor: AppColors.kGreen);
          },
        );
      }
    }
  }
}
