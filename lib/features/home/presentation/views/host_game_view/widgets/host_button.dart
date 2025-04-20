import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/app_cupit/app_cubit.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';

class HostButton extends StatelessWidget {
  const HostButton({super.key, required this.game});
  final GameModel game;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kBrightBLue, AppColors.kTeal],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: () => _showPasswordDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        child: Text(
          context.read<AppCubit>().strings[AppStrings.hostGame]!,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
  
  Future<void> _showPasswordDialog(BuildContext context) async {
    final controller = TextEditingController();
    String? password = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.read<AppCubit>().strings[AppStrings.hostGame]!),
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
            Navigator.of(context).pop(value.isEmpty ? null : value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Skip'),
          ),
          TextButton(
            onPressed: () {
              final value = controller.text;
              Navigator.of(context).pop(value.isEmpty ? null : value);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

   game.password=password;
      context.read<IntiateGameCubit>().hostGame(game);
    }
  }


