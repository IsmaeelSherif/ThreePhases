import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/core/widgets/rainbow_title.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/widgets/category_grid.dart';
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
          showSnackBar(context, message: AppStrings.someThingWentWrong);
        }
        else if (state is IntiateGameSuccess) {
         context.push(AppRoutes.hostedGameView, extra: game);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is IntiateGameLoading,
          child: GradientScaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.only(top: height * 0.05),
              child: Column(
                children: [
                  const RainbowTitle(),
                  const SizedBox(height: 32),
                  Flexible(child: CategoryGrid(game: game)),
                  const SizedBox(height: 12),
                  // LanguageList(game: game),
                  // const SizedBox(height: 24),
                  HostButton(game: game),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
