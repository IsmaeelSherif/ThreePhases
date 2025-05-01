import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';

class GameTimer extends StatefulWidget {
  const GameTimer({super.key, required this.game});
  final GameModel game;

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  final TextEditingController _controller = TextEditingController();
  late bool _showEditField;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showEditField = false;
  }
  void _handleEditTime() {
    setState(() {
      _showEditField = true;
      _controller.text = widget.game.turnTime.toString();
    });
  }

  void _saveNewTime() {
    final newTime = int.tryParse(_controller.text) ?? widget.game.turnTime;

    handleSave() {
      widget.game.turnTime = newTime;
      context.read<GameCubit>().updateGame(widget.game);
      setState(() => _showEditField = false);
    }

    if (widget.game.password?.isNotEmpty ?? false) {
      GameConfirmationDialogs.showPasswordConfirmationDialog(
        context: context,
        game: widget.game,
        title: AppStrings.saveChanges,
        content: AppStrings.saveTimeConfirmation,
        onConfirm: handleSave,
      );
    } else {
      GameConfirmationDialogs.showConfirmationDialog(
        context: context,
        game: widget.game,
        title: AppStrings.saveChanges,
        content: AppStrings.saveTimeConfirmation,
        onConfirm: handleSave,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.turnTime,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 4),
        _showEditField
            ? SizedBox(
              width: 60,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            )
            : Text(
             " ${widget.game.turnTime.toString()} Sec",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
        const SizedBox(width: 12),
        IconButton(
          icon: Icon(
            _showEditField ? Icons.save : Icons.edit,
            color: Colors.white,
          ),
          onPressed: _showEditField ? _saveNewTime : _handleEditTime,
        ),
      ],
    );
  }
}
