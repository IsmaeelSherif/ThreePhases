


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';

class HostedGameAppBar extends StatelessWidget {
  const HostedGameAppBar({
    super.key,
    required this.game,
    required this.updatedGame,
  });

  final GameModel game;
  final GameModel updatedGame;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      automaticallyImplyLeading: false,

      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          GoRouter.of(context).pop();
        },
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          "${AppStrings.gameCode} ${game.code}",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 18, color: Colors.white),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () async{
              if (!updatedGame.turnAvailable) {
                if(updatedGame.password ==null || updatedGame.password!.isEmpty){
                context.push(AppRoutes.wordsDoneView, extra: updatedGame);
                }
                else{
                  GameConfirmationDialogs.showPasswordConfirmationDialogForDoneWords(
                    context: context,
                    game: updatedGame,
                  );
                
                }
              } else {
                showSnackBar(
                  context,
                  message:
                      "Turn is available for the players wait untill they finish it",
                );
              }
            },
            child: Text(
              "${AppStrings.wordsDone} ${updatedGame.doneWordIndexes.length}/${updatedGame.wordsCount}",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
