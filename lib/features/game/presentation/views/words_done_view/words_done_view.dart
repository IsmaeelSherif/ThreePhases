import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/widgets/game_confirmation_dialogs.dart';

class WordsDoneView extends StatefulWidget {
  const WordsDoneView({super.key, required this.game});
  final GameModel game;

  @override
  State<WordsDoneView> createState() => _WordsDoneViewState();
}

class _WordsDoneViewState extends State<WordsDoneView> {
  late List<int> localDoneWordIndexes;
  late List<int> localLastTurnDoneWords;
  @override
  void initState() {
    super.initState();
    localDoneWordIndexes = List<int>.from(widget.game.doneWordIndexes);
    localLastTurnDoneWords = List<int>.from(widget.game.lastTurnDoneWords);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> doneWords =
        localDoneWordIndexes
            .map((i) => {"index": i, "engWord": widget.game.words[i].englishWord, "arWord": widget.game.words[i].arabicWord})
            .toList()
            .reversed
            .toList();
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state is GameError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        else if (state is GameUpdated) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is GameLoading,
          child: GradientScaffold(
            appBar: AppBar(title: const Text('Words Done')),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Words Done',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
     
                  const SizedBox(height: 16),
                  Expanded(
                    child:
                        doneWords.isEmpty
                            ? Center(
                              child: Text(
                                'No words done yet.',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            )
                            : ListView.separated(
                              itemCount: doneWords.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, idx) {
                                final item = doneWords[idx];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      child: Text(
                                        '${idx + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      "${item["engWord"]} - ${item["arWord"]}",
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      tooltip: 'Remove',
                                      onPressed: () {
                                        setState(() {
                                          localDoneWordIndexes.remove(
                                            item["index"],
                                          );
                                          localLastTurnDoneWords.remove(
                                            item["index"],
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if(widget.game.password != null && widget.game.password!.isNotEmpty) {
                          GameConfirmationDialogs.showPasswordConfirmationDialog(
                            context: context,
                            game: widget.game,
                            title: AppStrings.saveDoneWords,
                            content: AppStrings.saveDoneWordsConfirmation,
                            onConfirm: () {
                               widget.game.doneWordIndexes = localDoneWordIndexes;
                               widget.game.lastTurnDoneWords = localLastTurnDoneWords;
                        context.read<GameCubit>().updateGame(widget.game);
                        context.pop();
                            },
                          );
                        } else {
                          GameConfirmationDialogs.showConfirmationDialog(
                            context: context,
                            game: widget.game,
                            title: AppStrings.saveDoneWords,
                            content: AppStrings.saveDoneWordsConfirmation,
                            onConfirm: () {
                              widget.game.doneWordIndexes = localDoneWordIndexes;
                              widget.game.lastTurnDoneWords = localLastTurnDoneWords;
                              context.read<GameCubit>().updateGame(widget.game);
                              context.pop();
                            },
                          );
                        }
                      },
                      label: const Text('Save'),
                    ),
                  ),
                   const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
