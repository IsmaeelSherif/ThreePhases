import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';

class GameFinishedView extends StatelessWidget {
  const GameFinishedView({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Finished',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.homeView);
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
