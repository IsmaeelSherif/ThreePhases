import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_strings.dart';

class TimeLeftWidget extends StatelessWidget {
  const TimeLeftWidget({
    super.key,
    required this.updatedGame,
  });

  final GameModel updatedGame;

  @override
  Widget build(BuildContext context) {
    if (updatedGame.turnEndsTime == null) {
      return const SizedBox();
    }

    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        // Use a FutureBuilder to get the NTP time
        return FutureBuilder<DateTime>(
          future: NTP.now(),
          builder: (context, ntpSnapshot) {
            if (!ntpSnapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final now = ntpSnapshot.data!;
            final end = updatedGame.turnEndsTime!;
            final difference = end.difference(now);

            if (difference.isNegative) {
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
              style: Theme.of(context).textTheme.bodyLarge,
            );
          },
        );
      },
    );
  }
}
