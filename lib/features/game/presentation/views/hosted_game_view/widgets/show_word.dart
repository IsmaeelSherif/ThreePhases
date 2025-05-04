import 'package:flutter/material.dart';
import 'package:three_phases/core/models/game_model.dart';

class ShowWord extends StatefulWidget {
  const ShowWord({super.key, required this.updatedGame});

  final GameModel updatedGame;

  @override
  State<ShowWord> createState() => _ShowWordState();
}

class _ShowWordState extends State<ShowWord> {
  late bool showWord ;
  @override
  void initState() {
    showWord = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          TextButton(
            onPressed: () {
              setState(() {
                showWord = !showWord;
              });
            },
            child: Text(
              !showWord ? "Show Word" : "Hide Word",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 22, 17, 168),
              ),
            ),
          ),
          showWord
              ? Text(
                "${widget.updatedGame.words[widget.updatedGame.lastWordIndex].englishWord} / ${widget.updatedGame.words[widget.updatedGame.lastWordIndex].arabicWord}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
              : SizedBox(),
          const SizedBox(height: 16),
      ],
    );
  }
}