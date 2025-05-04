import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';

class GameConfirmationDialogs {
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required GameModel game,
    required VoidCallback onConfirm,
    String title = 'Are you sure?',
    String content = 'This action cannot be undone',
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

static Future<bool> showPasswordConfirmationDialog({
  required BuildContext context,
  required GameModel game,
  required VoidCallback onConfirm,
  bool? customWords,

  GameCubit? gameCubit,
  bool?remove,
  String title = 'Enter Password',
  String content = 'This action requires password verification',

}) {
  final TextEditingController controller = TextEditingController();

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(content),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Password',
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true); // Return true
            if (controller.text == game.password) {
              if(gameCubit==null)
             {
              if(customWords==true){
              context.push(AppRoutes.wordsDoneView, extra: game);
              }
               onConfirm();
               } // Call the callback
             else{
            String word= "${game.words[game.lastWordIndex].englishWord} / ${game.words[game.lastWordIndex].arabicWord}";
            if(remove==true){
            game.doneWordIndexes.remove(game.lastWordIndex);
            game.lastTurnDoneWords.remove(game.lastWordIndex);
            gameCubit.updateGame(
              game,
            );
            showSnackBar(context, message: "$word has been removed from done words",backgroundColor: AppColors.kGreen);
            }
            else if(remove==false){
                game.doneWordIndexes.add(
            game.lastWordIndex,
          );
          game.lastTurnDoneWords.add(
            game.lastWordIndex,
          );
          gameCubit.updateGame(
            game,
          );
          showSnackBar(context, message: "$word has been added to done words",backgroundColor: AppColors.kGreen);
          
            }
             }
            } else {
              showSnackBar(context, message: AppStrings.wrongPassword);
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  ).then((value) => value ?? false); // If dismissed, return false
}

  static Future<void> showEditTurnTimeDialog({
    required BuildContext context,
    required GameModel game,
    String title = AppStrings.editTurnTime,
    String content = "Enter new turn time in seconds",
    required GameCubit gameCubit,
  }) {
    final TextEditingController controller = TextEditingController(text: game.turnTime.toString());
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(content),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Seconds',
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              int? newTime = int.tryParse(controller.text);
              if (newTime != null) {
                if(newTime<=0){
                  newTime=1;
                }
                Navigator.pop(context);
                GameModel updatedGame = GameModel(
                  code: game.code,
                  categories: game.categories,
                  wordsCount: game.wordsCount,
                  turnTime: newTime,
                  password: game.password,
                  words: game.words,
                  turnNumber: game.turnNumber,
                  turnAvailable: game.turnAvailable,
                  turnFinished: game.turnFinished,
                  lastWordIndex: game.lastWordIndex,
                  doneWordIndexes: game.doneWordIndexes,
                  lastTurnDoneWords: game.lastTurnDoneWords,
                  createdAt: game.createdAt,
                );
                if (game.password?.isNotEmpty ?? false) {
                  GameConfirmationDialogs.showPasswordConfirmationDialog(
                    context: context,
                    game: updatedGame,
                    title: AppStrings.saveChanges,
                    content: AppStrings.saveTimeConfirmation,
                    onConfirm: () => gameCubit.updateGame(updatedGame),
                  );
                } else {
              
                  gameCubit.updateGame(updatedGame);
                }
              } else {
                showSnackBar(context, message: 'Invalid time');
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}