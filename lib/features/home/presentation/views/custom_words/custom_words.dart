import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/models/words_model.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';
import 'package:three_phases/features/home/presentation/views/home_view/widgets/intiate_game_dialogs.dart';

class CustomWords extends StatefulWidget {
  const CustomWords({super.key, required this.game});
  final GameModel game;

  @override
  State<CustomWords> createState() => _CustomWordsState();
}

class _CustomWordsState extends State<CustomWords> {
  late List<WordsModel> words;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    words = [];
  }

  void _addWord() {
    GameConfirmationDialogs.showConfirmationDialog(
      context: context,
      game: widget.game,
      content: "You showre u want to add ${_controller.text} to words?",
      onConfirm: () {
        final text = _controller.text.trim();
        if (text.isNotEmpty && !words.any((w) => w.englishWord == text)) {
          setState(() {
            words.add(
              WordsModel(englishWord: text, arabicWord: '', category: ''),
            );
          });
          _controller.clear();
          _focusNode.unfocus();
        } else if (text.isEmpty) {
          showSnackBar(context, message: "Please enter a word");
        } else if (words.any((w) => w.englishWord == text)) {
          showSnackBar(context, message: "Word already exists");
        }
      },
    );
  }

  void _removeWord(int index) {
    GameConfirmationDialogs.showConfirmationDialog(
      context: context,
      game: widget.game,
      content: "You showre u want to remove the last word from words?",
      onConfirm: () {
        setState(() {
          words.removeAt(index);
        });
      },
    );
  }

  void _hostGame(BuildContext context) {
    final updatedGame = GameModel(
      code: widget.game.code,
      categories: widget.game.categories,
      words: words,
      password: widget.game.password,
      turnNumber: widget.game.turnNumber,
      turnAvailable: widget.game.turnAvailable,
      turnFinished: widget.game.turnFinished,
      wordsCount: words.length,
      turnTime: widget.game.turnTime,
      lastWordIndex: widget.game.lastWordIndex,
      doneWordIndexes: widget.game.doneWordIndexes,
      createdAt: widget.game.createdAt,
    );
    IntiateGameDialogs.showPasswordDialog(
      context,
      context.read<IntiateGameCubit>(),
      updatedGame,
      customWords: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IntiateGameCubit, IntiateGameState>(
      listener: (context, state) {
        if (state is IntiateGameError) {
          showSnackBar(context, message: state.message);
        } else if (state is IntiateGameSuccess) {
          context.pushReplacement(AppRoutes.hostedGameView, extra: state.game);
        }
      },
      builder: (context, state) {
        final height = MediaQuery.of(context).size.height;
        return ModalProgressHUD(
          inAsyncCall: state is IntiateGameLoading,
          child: GradientScaffold(
            appBar: AppBar(
              title: const Text('Custom Words'),
              centerTitle: true,
              elevation: 0,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.15),
                    words.isEmpty
                        ? Center(
                          child: Text(
                            'No words added yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Number of Words: ${words.length}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SizedBox(height: 32),
                                ElevatedButton(
                                  onPressed:
                                      () => _removeWord(words.length - 1),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Remove Last Word',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    const SizedBox(height: 48),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: AppColors.kButtonBackgroundColorTransparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _controller,
                                focusNode: _focusNode,
                                onTapUpOutside: (event) => _focusNode.unfocus(),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white),

                                  labelText: 'Enter a new word',
                                  border: InputBorder.none,
                                ),
                                onFieldSubmitted: (_) => _addWord(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: _addWord,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: const SizedBox()),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            words.isNotEmpty && (state is! IntiateGameLoading)
                                ? () => _hostGame(context)
                                : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Host Game'),
                      ),
                    ),
                    const SizedBox(height: 32),
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
