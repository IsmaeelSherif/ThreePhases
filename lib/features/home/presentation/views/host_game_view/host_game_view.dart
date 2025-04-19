import 'package:flutter/material.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/core/widgets/rainbow_title.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/widgets/category_grid.dart';

class HostGameView extends StatelessWidget {
  const HostGameView({super.key});

  @override
  Widget build(BuildContext context) {
      final height=MediaQuery.of(context).size.height;

    return  GradientScaffold(
      appBar: AppBar(),
      body: 
    Padding(
      padding: EdgeInsets.only(top: height *0.05),
      child: Column(
        children: [
        const RainbowTitle(),
        const SizedBox(height: 32),
        Expanded(child: CategoryGrid()),
        const SizedBox(height: 16),      

        ],
      ),
    ),);
  }
}