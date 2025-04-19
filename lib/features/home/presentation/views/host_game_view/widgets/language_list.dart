import 'package:flutter/material.dart';

import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/widgets/custtom_button.dart';

// ignore: must_be_immutable
class LanguageList extends StatefulWidget {
   const LanguageList({super.key, required this.game});
   final GameModel game;

  @override
  State<LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  @override
 
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CusttomButton(
          text: GameLanguage.english.value,
          onPressed: (){
            setState(() {
            widget.game.language =GameLanguage.english;
              
            });
          },         
          isSelected: widget.game.language == GameLanguage.english,
        ),
        const SizedBox(width: 10),
        CusttomButton(
          text: GameLanguage.arabic.value,
          onPressed: (){
            setState(() {
            widget.game.language =GameLanguage.arabic;
              
            });
          },
          isSelected: widget.game.language == GameLanguage.arabic,
        ),
      ],
    );
  }
}