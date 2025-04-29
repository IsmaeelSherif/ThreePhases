import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';

class HostButton extends StatelessWidget {
  const HostButton({super.key, required this.game});
  final GameModel game;

  @override
  Widget build(BuildContext context) {
    final cubit=context.read<IntiateGameCubit>();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kBrightBlue, AppColors.kTeal],
        ),
        // color: AppColors.kPrimaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: () => _showPasswordDialog(context,cubit),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        child: Text(
          AppStrings.hostGame,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
  
  Future<void> _showPasswordDialog(BuildContext context,IntiateGameCubit cubit) async {
    final controller = TextEditingController();
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.hostGame),
        
        content: TextField(
          controller: controller,
          maxLength: 6,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration:  InputDecoration(
            hintText: 'Enter password (optional)',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            game.password = value.isEmpty ? null : value;
            cubit.hostGame(game);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () { 
              game.password= null;
              cubit.hostGame(game);
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.skip),
          ),
          TextButton(
            onPressed: () {
              final value = controller.text;
              game.password = value.isEmpty ? null : value;
              cubit.hostGame(game);
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  
    }
  }


