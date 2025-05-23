import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:three_phases/core/utils/enums/game_enums.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';

class IntiateGameDialogs {
  static Future<void> showJoinGameDialog(
    BuildContext context,
    IntiateGameCubit cubit,
    {bool isHost = false}
  ) async {
    final codeController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            title: Text(AppStrings.joinGame),
            content: TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: AppStrings.enter6DigitCode,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () async {
                  final code = codeController.text;
                  if (code.length != 6) {
                    showSnackBar(context, message: AppStrings.enter6DigitCode);
                    return;
                  }
                  cubit.joinGame(code, isHost: isHost);

                  Navigator.pop(context);
                },
                child: Text(AppStrings.join),
              ),
            ],
          ),
    );
  }

  /// Dialog 1: Join Last Game or Join Another Game
  static Future<void> showInitialJoinDialog(
    BuildContext context,
    IntiateGameCubit cubit,
    String code,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              AppStrings.joinGame,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    cubit.joinGame(code);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.joinLastGame,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.kPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    IntiateGameDialogs.showJoinGameDialog(context, cubit);
                  },
                  child: Text(
                    AppStrings.joinAnotherGame,
                    style: TextStyle(color: AppColors.kPrimaryColor),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Dialog 2: Join Last Game or Host New One
  static Future<void> showLastOrHostDialog(
    BuildContext context,
    IntiateGameCubit cubit,
    String? code,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              AppStrings.hostGame,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
             code != null ? Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    cubit.joinGame(code, isHost: true);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.joinLastGame,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ):const SizedBox(height: 10),
              const SizedBox(height: 10),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.kPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(
                      AppRoutes.hostView,
                      extra: GameModel(
                        code: '',
                        categories: GameCategory.values.where((category) => category != GameCategory.customWords).toList(),
                        wordsCount: 40,
                        turnTime: 20,
                      ),
                    );
                  },
                  child: Text(
                    AppStrings.hostNewGame,
                    style: TextStyle(color: AppColors.kPrimaryColor),
                  ),
                ),
              ),
               const SizedBox(height: 10),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.kPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    IntiateGameDialogs.showJoinGameDialog(context, cubit, isHost: true);
                  },
                  child: Text(
                    AppStrings.joinGameAsHost,
                    style: TextStyle(color: AppColors.kPrimaryColor),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  static Future<void> showPasswordDialog(BuildContext context,IntiateGameCubit cubit, GameModel game, {bool customWords = false}) async {
    final controller = TextEditingController();
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.hostGame),
        
        content: TextField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
          decoration:  InputDecoration(
            hintText: 'Enter password (optional)',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            game.password = value.isEmpty ? null : value;
            cubit.hostGame(game, customWords: customWords);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () { 
              game.password= null;
              cubit.hostGame(game, customWords: customWords);
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.skip),
          ),
          TextButton(
            onPressed: () {
              final value = controller.text;
              game.password = value.isEmpty ? null : value;
              cubit.hostGame(game, customWords: customWords);
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  
    }

  static Future<void> showAdminPasswordDialog(
    BuildContext context,
    
  ) async {
    final controller = TextEditingController();
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('Admin Access'),
        content: TextField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter Admin Password',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
            border: const OutlineInputBorder(),
          ),
          obscureText: true,
          onSubmitted: (value) {
            if (value == 'Test123') { // You should replace this with a secure password check
              Navigator.of(context).pop();
              context.push(AppRoutes.unverifiedWordsView);
            } else {
              showSnackBar(context, message: 'Invalid password');
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              final value = controller.text;
              if (value == 'Test123') { // You should replace this with a secure password check
                Navigator.of(context).pop();
                context.push(AppRoutes.unverifiedWordsView);
              } else {
                showSnackBar(context, message: 'Invalid password');
              }
            },
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }

}
