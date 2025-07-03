import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ntp/ntp.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/features/game/data/repo/game_repo.dart';
// import 'package:timezone/browser.dart' as tz;

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());
  DateTime? globalTime;
  final gameRepo = GetIt.instance.get<GameRepo>();
  bool isTurnStarted = false;
  bool isDialogOpen = false;
  initDate() async {
    globalTime = await NTP.now();
  }
  void startTurn(GameModel game) async{
    // emit(GameLoading());
    isTurnStarted = true;
    if (game.turnEndsTime != null) {
      emit(GameTurnStarted());
      return;
    }
    game.turnFinished = false;
    game.turnAvailable = true;
    final now = await NTP.now();
    game.turnEndsTime = now.add(Duration(seconds: game.turnTime));
    game.lastTurnDoneWords = [];
    game.lastWordIndex = -1;
    globalTime = now;
    nextWord(game);
  }


void nextWord(GameModel game) {
  // emit(GameLoading());

  if (game.lastWordIndex != -1) {

  game.doneWordIndexes.add(game.lastWordIndex);
  game.lastTurnDoneWords.add(game.lastWordIndex);
  }
  final totalWords = game.words.length;
  final usedIndexes = Set<int>.from(game.doneWordIndexes);
  final unusedIndexes = List<int>.generate(totalWords, (i) => i)
      .where((index) => !usedIndexes.contains(index))
      .toList();

  if (unusedIndexes.isEmpty) {
    finishTurn(game,lastWordIndex: -1);
    return;
  }
  final random = Random();
  final nextIndex = unusedIndexes[random.nextInt(unusedIndexes.length)];

  game.lastWordIndex = nextIndex;

  updateGame(game);
}

  void finishTurn(
    GameModel game, {
    List<int>? updatedDoneWordIndexes,
    List<int>? lastTurnDoneWords,
    int? lastWordIndex,
  }) {
    // emit(GameLoading());
    isTurnStarted = false;
    game.turnFinished = true;
    game.turnAvailable = false;
    game.turnEndsTime = null;

    if (updatedDoneWordIndexes != null) game.doneWordIndexes = updatedDoneWordIndexes;
    if (lastTurnDoneWords != null) game.lastTurnDoneWords = lastTurnDoneWords;
    game.lastWordIndex = lastWordIndex ?? game.lastWordIndex;

    updateGame(game);
  }

  void updateGame(GameModel game) async {
    final result = await gameRepo.updateGame(game);
    result.fold(
      (error) => emit(GameError(message: error.message)),
      (_) => {
        // emit(GameUpdated())
        },
    );
  }
}
