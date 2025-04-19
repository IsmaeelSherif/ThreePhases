import 'package:flutter/material.dart';

import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/utils/app_colors.dart';

// ignore: must_be_immutable
class LanguageList extends StatefulWidget {
   LanguageList({super.key, required this.selectedLanguage});
   GameLanguage selectedLanguage;

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
        ElevatedButton(
          onPressed: (){
            setState(() {
            widget.selectedLanguage =GameLanguage.english;
              
            });
          },
           style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.selectedLanguage == GameLanguage.english ? AppColors.kPrimaryColor : AppColors.kSeconderyTextColor,
                  foregroundColor: widget.selectedLanguage == GameLanguage.english ? AppColors.kPrimaryColor : AppColors.kSeconderyTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
          child:  Text(GameLanguage.english.value,style: Theme.of(context).textTheme.bodyLarge,),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: (){
            setState  (() {
            widget.selectedLanguage =GameLanguage.arabic;
              
            });
          },
          style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.selectedLanguage == GameLanguage.arabic ? AppColors.kPrimaryColor : AppColors.kSeconderyTextColor,
                  foregroundColor: widget.selectedLanguage == GameLanguage.arabic ? AppColors.kPrimaryColor : AppColors.kSeconderyTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
          child:  Text(GameLanguage.arabic.value,style: Theme.of(context).textTheme.bodyLarge,),
        )
      ],
    );
  }
}