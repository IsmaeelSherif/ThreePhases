import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:three_phases/core/utils/app_routes.dart';

import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/core/widgets/rainbow_title.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/features/game/presentation/views/joined_game_view/widgets/custom_turn_button.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/widgets/category_section.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/widgets/game_setting.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/widgets/host_button.dart';

class HostGameView extends StatelessWidget {
  const HostGameView({super.key, required this.game});

  final GameModel game;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocConsumer<IntiateGameCubit, IntiateGameState>(
      listener: (context, state) {
        if (state is IntiateGameError) {
          showSnackBar(context, message: state.message);
        }
        else if (state is IntiateGameSuccess) {
         context.pushReplacement(AppRoutes.hostedGameView, extra: game);
         return ;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is IntiateGameLoading,
          child: GradientScaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, height * 0.05, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const RainbowTitle(),
                        const SizedBox(height: 48),
                        CategoryMultiSelectDropdown(game: game),
                        const SizedBox(height: 48),
                        Gamesetting(game: game),
                        const SizedBox(height: 48),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: CustomTurnButton(
                            onPressed: () {
                              context.push(AppRoutes.customWordsView, extra: game);
                            },
                            text: ' Use Custom Words',
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: HostButton(game: game)),
                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
