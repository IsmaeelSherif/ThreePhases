import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/app_cupit/app_cubit.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';
import 'package:go_router/go_router.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';

class PlayButtons extends StatelessWidget {
  const PlayButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kButtonBackgroundColor.withOpacity(
                    0.2,
                  ),
                  foregroundColor: AppColors.kButtonBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 15,
                  ),
                ),
                onPressed: () {
                  context.push(
                    AppRoutes.hostView,
                    extra: GameModel(
                      code: '',
                      categories: GameCategory.values.toList(),
                      language: context.read<AppCubit>().currentLanguage,
                    ),
                  );
                },
                child: Text(
                  context.read<AppCubit>().strings[AppStrings.hostGame]!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kButtonBackgroundColor.withOpacity(
                    0.2,
                  ),
                  foregroundColor: AppColors.kButtonBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 15,
                  ),
                ),
                onPressed: () => _showJoinGameDialog(context, context.read<IntiateGameCubit>()),
                child: Text(
                  context.read<AppCubit>().strings[AppStrings.joinGame]!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showJoinGameDialog(BuildContext context, IntiateGameCubit cubit) async {
    final codeController = TextEditingController();

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.read<AppCubit>().strings[AppStrings.joinGame]!),
            content: TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: context.read<AppCubit>().strings[AppStrings.enter6DigitCode]!,
              ),
              maxLength: 6,
              keyboardType: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  context.read<AppCubit>().strings[AppStrings.cancel]!,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final code = codeController.text;
                  if (code.length != 6) {
                    showSnackBar(
                      context,
                      message: context.read<AppCubit>().strings[AppStrings.enter6DigitCode]!,
                    );
                    return;
                  }
                  cubit.joinGame(code);
              
                   Navigator.pop(context);
                  // TODO: Navigate to game screen with the game data
                },
                child: Text(context.read<AppCubit>().strings[AppStrings.join]!),
              ),
            ],
          ),
    );
  }
}
