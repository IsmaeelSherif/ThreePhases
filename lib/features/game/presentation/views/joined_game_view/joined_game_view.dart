import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';
import 'dart:async';

import 'package:three_phases/features/game/presentation/views/joined_game_view/widgets/game_section.dart';

class JoinedGameView extends StatelessWidget {
  const JoinedGameView({super.key, required this.game});
  final GameModel game;

  Stream<GameModel> _getGameStream() {
    return FirebaseFirestore.instance
        .collection('games')
        .doc(game.code)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.data() != null
                  ? GameModel.fromMap(snapshot.data()!)
                  : game,
        );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            GameConfirmationDialogs.showConfirmationDialog(
              context: context,
              game: game,
              title: AppStrings.leaveGame,
              content: AppStrings.leaveGameConfirmation,
              onConfirm: () {
                context.pop();
              },
            );
          }
        )
        ,title:  Text('${AppStrings.gameCode} ${game.code}')),
      body: SafeArea(
        child: StreamBuilder<GameModel>(
          stream: _getGameStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final updatedGame = snapshot.data ?? game;
            // if (updatedGame.turnNumber > 3) {
            //   final sharedPerf = GetIt.instance.get<SharedPreferences>();
            //   sharedPerf.remove(AppStrings.lastJoinedGameCode);
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     GoRouter.of(
            //       context,
            //     ).pushReplacement(AppRoutes.gameFinishedView);
            //   });
            // }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
 
                    // Text(
                    //   "${AppStrings.phase} ${updatedGame.turnNumber} of 3",
                    //   style: Theme.of(
                    //     context,
                    //   ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    // ),

                    GameSection(updatedGame: updatedGame),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
