import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_colors.dart';

class Gamesetting extends StatefulWidget {
  const Gamesetting({super.key, required this.game});
  final GameModel game;

  @override
  State<Gamesetting> createState() => _GamesettingState();
}

class _GamesettingState extends State<Gamesetting> {
  final TextEditingController _turnTimeController = TextEditingController();
  final TextEditingController _wordsCountController = TextEditingController();
  final FocusNode _timeFocusNode = FocusNode();
  final FocusNode _countFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _turnTimeController.text = widget.game.turnTime.toString();
    _wordsCountController.text = widget.game.wordsCount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: _timeFocusNode,
              onTapOutside: (event) {
                _timeFocusNode.unfocus();
                final value = _turnTimeController.text;
                int? v = int.tryParse(value);
                if (v == null) return;
                if (v < 2) v = 2;
                if (v > 60) v = 60;
                if (v.toString() != value) {
                  _turnTimeController.text = v.toString();
                  _turnTimeController.selection = TextSelection.fromPosition(TextPosition(offset: _turnTimeController.text.length));
                }
                widget.game.turnTime = v;
              },
              onFieldSubmitted: (value) {
                int? v = int.tryParse(value);
                if (v == null) return;
                if (v < 2) v = 2;
                if (v > 60) v = 60;
                if (v.toString() != value) {
                  _turnTimeController.text = v.toString();
                  _turnTimeController.selection = TextSelection.fromPosition(TextPosition(offset: _turnTimeController.text.length));
                }
                widget.game.turnTime = v;
              },
              controller: _turnTimeController,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Turn Time in sec',
                labelStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.kWhite,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.kSecondaryColor),
                ),
                filled: true,
                fillColor: AppColors.kTransparentWhite,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                // Only update controller, don't clamp here
              },
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: TextFormField(
              focusNode: _countFocusNode,
              onTapOutside: (event) {
                _countFocusNode.unfocus();
                final value = _wordsCountController.text;
                int? v = int.tryParse(value);
                if (v == null) return;
                if (v < 20) v = 20;
                if (v > 100) v = 100;
                if (v.toString() != value) {
                  _wordsCountController.text = v.toString();
                  _wordsCountController.selection = TextSelection.fromPosition(TextPosition(offset: _wordsCountController.text.length));
                }
                widget.game.wordsCount = v;
              },
              onFieldSubmitted: (value) {
                int? v = int.tryParse(value);
                if (v == null) return;
                if (v < 20) v = 20;
                if (v > 100) v = 100;
                if (v.toString() != value) {
                  _wordsCountController.text = v.toString();
                  _wordsCountController.selection = TextSelection.fromPosition(TextPosition(offset: _wordsCountController.text.length));
                }
                widget.game.wordsCount = v;
              },
              controller: _wordsCountController,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Words Count',
                labelStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.kWhite,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.kSecondaryColor),
                ),
                filled: true,
                fillColor: AppColors.kTransparentWhite,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                // Only update controller, don't clamp here
              },
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
