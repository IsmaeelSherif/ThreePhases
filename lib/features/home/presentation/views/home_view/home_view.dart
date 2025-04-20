import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';
import 'package:three_phases/features/home/presentation/views/home_view/widgets/play_buttons.dart';
import 'package:three_phases/core/widgets/rainbow_title.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocConsumer<IntiateGameCubit, IntiateGameState>(
      listener: (context, state) {
        if (state is IntiateGameError) {
          showSnackBar(context, message: state.message);
        }
        else if(state is IntiateGameSuccess) {
          context.push(AppRoutes.joinView, extra: state.game);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is IntiateGameLoading,
          child: GradientScaffold(    
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const RainbowTitle(),
                    SizedBox(height: height * 0.15),
                    PlayButtons(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
