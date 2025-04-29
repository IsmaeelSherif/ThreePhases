import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';
import 'package:three_phases/features/game/presentation/views/joined_game_view/widgets/custom_turn_button.dart';

class GameSection extends StatefulWidget {
  const GameSection({super.key, required this.updatedGame});

  final GameModel updatedGame;

  @override
  State<GameSection> createState() => _GameSectionState();
}

class _GameSectionState extends State<GameSection> {
  Timer? _timer;
  int _timeLeft = 0;
  bool _isShowingWord = false;
  DateTime? _lastPressedAt;
  List<int>? _lastTurnDoneWords;
  List<int>? _doneWordIndexes;
  int? _lastWordIndex;
  @override
  void initState() {
    _doneWordIndexes = widget.updatedGame.doneWordIndexes;
    _lastTurnDoneWords = [];
    _lastWordIndex = widget.updatedGame.lastWordIndex;
    super.initState();
  }

  void _startTurn(GameModel game) {
    setState(() {
      _doneWordIndexes = widget.updatedGame.doneWordIndexes;
      _lastTurnDoneWords = [];
      _lastWordIndex = widget.updatedGame.lastWordIndex;
      _isShowingWord = true;
      _timeLeft = game.turnTime;
      // Find the first available word index
      final availableIndexes =
          game.words
              .asMap()
              .keys
              .where((idx) => !game.doneWordIndexes.contains(idx))
              .toList();

      if (availableIndexes.isNotEmpty) {
        final random = Random();
        final randomIdx =
            availableIndexes[random.nextInt(availableIndexes.length)];
        _lastWordIndex = randomIdx;
        game.lastWordIndex = randomIdx;
      } else {
        game.lastWordIndex = -1; // No available words
        _lastWordIndex = -1;
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _finishTurn(game, context);
      }
    });
  }

  Future<void> _finishTurn(GameModel game, BuildContext context) async {
    _timer?.cancel();
    setState(() {
      _isShowingWord = false;
    });

    // final bool isLastWord = game.doneWordIndexes.length >= game.wordsCount;
    game.turnFinished = true;
    game.turnAvailable = false;
    game.doneWordIndexes = _doneWordIndexes!;
    game.lastTurnDoneWords = _lastTurnDoneWords!;
    game.lastWordIndex =
        _doneWordIndexes!.length >= game.words.length ? -1 : _lastWordIndex!;
    context.read<GameCubit>().updateGame(game);
  }

  void _updateGame(GameModel game, BuildContext context) {
    final now = DateTime.now();
    if (_lastPressedAt != null &&
        now.difference(_lastPressedAt!) < Duration(milliseconds: 1500)) {
      // Ignore click, throttle in effect
      return;
    }
    _lastPressedAt = now;
    setState(() {
      // Add current word to doneWordIndexes
      if (widget.updatedGame.lastWordIndex != -1) {
        widget.updatedGame.doneWordIndexes.add(
          widget.updatedGame.lastWordIndex,
        );
        widget.updatedGame.lastTurnDoneWords.add(
          widget.updatedGame.lastWordIndex,
        );
        _lastTurnDoneWords?.add(widget.updatedGame.lastWordIndex);
        _doneWordIndexes = widget.updatedGame.doneWordIndexes;
      }
      // Find the next available word index
      final nextIdx = widget.updatedGame.words.asMap().keys.firstWhere(
        (idx) => !widget.updatedGame.doneWordIndexes.contains(idx),
        orElse: () => -1,
      );
      widget.updatedGame.lastWordIndex = nextIdx;
      _lastWordIndex = nextIdx;
      context.read<GameCubit>().updateGame(widget.updatedGame);
      if (widget.updatedGame.doneWordIndexes.length ==
          widget.updatedGame.wordsCount) {
        _finishTurn(widget.updatedGame, context);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${AppStrings.wordsDone}: ${widget.updatedGame.doneWordIndexes.length}/${widget.updatedGame.wordsCount}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 32),
        if (!widget.updatedGame.turnAvailable)
          Text(AppStrings.waitingForHost, style: TextStyle(fontSize: 18))
        else if (!_isShowingWord)
          CusttomTurnButton(
            onPressed: () {
             GameConfirmationDialogs.showConfirmationDialog(
              context: context,
              title: AppStrings.startTurn,
              content: AppStrings.startTurnConfirmation,
              game: widget.updatedGame,
              onConfirm: () {
                _startTurn(widget.updatedGame);
              },
             );
            },
            text: AppStrings.startTurn,
          )
        else
          Column(
            children: [
              Text(
                '${AppStrings.timeLeft}: $_timeLeft seconds',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.kTransparentWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.updatedGame.lastWordIndex != -1
                          ? " ${widget.updatedGame.words[widget.updatedGame.lastWordIndex].englishWord}  / ${widget.updatedGame.words[widget.updatedGame.lastWordIndex].arabicWord}"
                          : '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _updateGame(widget.updatedGame, context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  AppStrings.nextWord,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

