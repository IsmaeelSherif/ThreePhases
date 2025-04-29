import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/models/words_model.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';
import 'package:three_phases/core/utils/app_routes.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';

class CustomWords extends StatefulWidget {
  const CustomWords({super.key, required this.game});
  final GameModel game;

  @override
  State<CustomWords> createState() => _CustomWordsState();
}

class _CustomWordsState extends State<CustomWords> {
  late List<WordsModel> words;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    words = [];
  }

  void _addWord() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !words.any((w) => w.englishWord == text)) {
      setState(() {
        words.add(WordsModel(englishWord: text, arabicWord: '', category: ''));
      });
      _controller.clear();
    }
  }

  void _removeWord(int index) {
    setState(() {
      words.removeAt(index);
    });
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
    context.read<IntiateGameCubit>().hostGame(updatedGame, customWords: true);
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
        return ModalProgressHUD(
          inAsyncCall: state is IntiateGameLoading,
          child: GradientScaffold(
            appBar: AppBar(title: const Text('Custom Words')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: words.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(words[index].englishWord,style: Theme.of(context).textTheme.bodyLarge),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeWord(index),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: 'Add a word',
                            ),
                            onSubmitted: (_) => _addWord(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: _addWord,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: words.isNotEmpty && (state is! IntiateGameLoading)
                            ? () => _hostGame(context)
                            : null,
                        child: const Text('Host Game'),
                      ),
                    ),
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