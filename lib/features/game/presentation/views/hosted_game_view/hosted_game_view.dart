import 'package:flutter/material.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';

class HostedGameView extends StatelessWidget {
  const HostedGameView({super.key, required this.game});
  final GameModel game;

  @override
  Widget build(BuildContext context) {
    return  GradientScaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Hosted Game', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 40)),
              SizedBox(height: 32),
              Text(game.toString(),style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}