import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_timer.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/last_word_proccess_section.dart';
import 'package:three_phases/features/game/presentation/views/joined_game_view/widgets/custom_turn_button.dart';

class HostedGameView extends StatelessWidget {
  const HostedGameView({super.key, required this.game});
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
    final height = MediaQuery.of(context).size.height;
    return GradientScaffold(
      body: SafeArea(
        child: StreamBuilder<GameModel>(
          stream: _getGameStream().distinct((prev, next) => prev == next),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final updatedGame = snapshot.data ?? game;
            return CustomScrollView(
              slivers: [
                HostedGameAppBar(game: game, updatedGame: updatedGame),
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * .1),
                      updatedGame.turnFinished &&
                              updatedGame.lastWordIndex != -1
                          ? LastWordProccessSection(updatedGame: updatedGame)
                          : SizedBox(),
                      !updatedGame.turnAvailable
                          ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                            ),
                            child: Column(
                              children: [
                                GameTimer(game: updatedGame),
                                SizedBox(height: 16.0),
                                CustomTurnButton(
                                  onPressed: () async {
                                    if (updatedGame.words.length ==
                                        updatedGame.doneWordIndexes.length) {
                                      showSnackBar(
                                        context,
                                        message:
                                            "All words have been guessed, Start New Phase",
                                      );
                                    } else if (updatedGame.password != null &&
                                        updatedGame.password!.isNotEmpty) {
                                      GameConfirmationDialogs.showPasswordConfirmationDialog(
                                        context: context,
                                        title: AppStrings.startTurn,
                                        content:
                                            AppStrings.startTurnConfirmation,
                                        game: updatedGame,
                                        onConfirm: () {
                                          updatedGame.turnAvailable = true;
                                          updatedGame.turnFinished = false;
                                          updatedGame.lastTurnDoneWords = [];
                                          updatedGame.lastWordIndex = -1;
                                          context.read<GameCubit>().updateGame(
                                            updatedGame,
                                          );
                                        },
                                      );
                                    } else {
                                      GameConfirmationDialogs.showConfirmationDialog(
                                        context: context,
                                        title: AppStrings.startTurn,
                                        content:
                                            AppStrings.startTurnConfirmation,
                                        game: updatedGame,
                                        onConfirm: () {
                                          updatedGame.turnAvailable = true;
                                          updatedGame.turnFinished = false;
                                          updatedGame.lastTurnDoneWords = [];
                                          updatedGame.lastWordIndex = -1;
                                          context.read<GameCubit>().updateGame(
                                            updatedGame,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  text: AppStrings.startTurn,
                                ),
                                SizedBox(height: 16.0),
                                CustomTurnButton(
                                  onPressed: () {
                                    if (updatedGame.password != null &&
                                        updatedGame.password!.isNotEmpty) {
                                      GameConfirmationDialogs.showPasswordConfirmationDialog(
                                        context: context,
                                        title: AppStrings.newPhase,
                                        content:
                                            AppStrings.newPhaseConfirmation,
                                        game: updatedGame,
                                        onConfirm: () {
                                          updatedGame.turnNumber =
                                              updatedGame.turnNumber + 1;
                                          updatedGame.words.shuffle();
                                          updatedGame.doneWordIndexes = [];
                                          updatedGame.lastTurnDoneWords = [];
                                          updatedGame.lastWordIndex = -1;
                                          updatedGame.turnFinished = false;
                                          context.read<GameCubit>().updateGame(
                                            updatedGame,
                                          );
                                        },
                                      );
                                    } else {
                                      GameConfirmationDialogs.showConfirmationDialog(
                                        context: context,
                                        title: AppStrings.newPhase,
                                        content:
                                            AppStrings.startTurnConfirmation,
                                        game: updatedGame,
                                        onConfirm: () {
                                          updatedGame.turnNumber =
                                              updatedGame.turnNumber + 1;
                                          updatedGame.words.shuffle();
                                          updatedGame.doneWordIndexes = [];
                                          updatedGame.lastTurnDoneWords = [];
                                          updatedGame.lastWordIndex = -1;
                                          updatedGame.turnFinished = false;
                                          context.read<GameCubit>().updateGame(
                                            updatedGame,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  text: AppStrings.newPhase,
                                ),
                              ],
                            ),
                          )
                          : Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.kButtonBackgroundColorTransparent,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            height: 200,
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    game.turnEndsTime != null
                                        ? AppStrings.turnStarted
                                        : AppStrings.turnAvailable,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  TimeLeftWidget(updatedGame: updatedGame),
                                ],
                              ),
                            ),
                          ),
                      SizedBox(height: 32),
                      Text(
                        AppStrings.lastTurnWords,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                updatedGame.lastTurnDoneWords.isNotEmpty
                    ? SliverList.separated(
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 8),
                      itemCount: updatedGame.lastTurnDoneWords.length,
                      itemBuilder: (context, index) {
                        final wordIndex =
                            updatedGame.lastTurnDoneWords[updatedGame
                                    .lastTurnDoneWords
                                    .length -
                                index -
                                1];
                        final word = updatedGame.words[wordIndex];

                        return Center(
                          child: Text(
                            "${word.englishWord} / ${word.arabicWord}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        );
                      },
                    )
                    : SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          AppStrings.noWordsInLastTurn,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TimeLeftWidget extends StatelessWidget {
  const TimeLeftWidget({
    super.key,
    required this.updatedGame,
  });

  final GameModel updatedGame;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(
        const Duration(seconds: 1),
      ),
      builder: (context, snapshot) {
        if (updatedGame.turnEndsTime == null) {
          return const SizedBox();
        }
    
        final now = DateTime.now();
        final end = updatedGame.turnEndsTime!;
        final difference = end.difference(now);
    
        if (difference.isNegative) {
          updatedGame.turnFinished = true;
          updatedGame.turnAvailable = false;
          updatedGame.turnEndsTime = null;
          context.read<GameCubit>().updateGame(updatedGame);
          return Text(
            "Time's up!",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.red),
          );
        }
    
        final minutes = difference.inMinutes
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        final seconds = difference.inSeconds
            .remainder(60)
            .toString()
            .padLeft(2, '0');
    
        return Text(
          "${AppStrings.timeLeft}: $minutes:$seconds",
          textAlign: TextAlign.center,
          style:
              Theme.of(
                context,
              ).textTheme.bodyLarge,
        );
      },
    );
  }
}

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
      title: Text(
        "${AppStrings.gameCode} ${game.code}",
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontSize: 18, color: Colors.white),
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
                  GameConfirmationDialogs.showPasswordConfirmationDialog(
                    context: context,
                    game: updatedGame,
                    onConfirm: () {
                    
             
                    },
                    customWords:true
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
