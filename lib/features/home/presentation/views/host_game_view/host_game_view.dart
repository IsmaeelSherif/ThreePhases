import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/app_cupit/app_cubit.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/core/widgets/rainbow_title.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/widgets/category_grid.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/widgets/language_list.dart';

class HostGameView extends StatefulWidget {
  const HostGameView({super.key});

  @override
  State<HostGameView> createState() => _HostGameViewState();
}

class _HostGameViewState extends State<HostGameView> {
  final Set<GameCategory> selectedCategories = Set.from(GameCategory.values);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return GradientScaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.05),
        child: Column(
          children: [
            const RainbowTitle(),
            const SizedBox(height: 32),
            Flexible(child: CategoryGrid()),
            const SizedBox(height: 16),
            LanguageList(selectedLanguage: context.read<AppCubit>().currentLanguage),
          ],
        ),
      ),
    );
  }
}