import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';

class TurnTimer extends StatefulWidget {
  final GameModel game;

  const TurnTimer({super.key, required this.game});

  @override
  State<TurnTimer> createState() => _TurnTimerState();
}

class _TurnTimerState extends State<TurnTimer> {
  late int timeLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    final game = widget.game;
    final endTime = game.turnEndsTime;

    if (endTime == null) return;

    final now = DateTime.now();
    final difference = endTime.difference(now).inSeconds;
    timeLeft = difference > 0 ? difference : 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 0) {
        timer.cancel();
        _finishTurn();
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void _finishTurn() {
    final cubit = context.read<GameCubit>();
    cubit.finishTurn(widget.game,);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time Left: $timeLeft s',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
    );
  }
}
