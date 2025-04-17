import 'package:flutter/material.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';

class PlayButtons extends StatelessWidget {
  const PlayButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:  CrossAxisAlignment.center,
      children: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kButtonBackgroundColor.withOpacity(0.2), 
              foregroundColor: AppColors.kButtonBackgroundColor, 
              padding: EdgeInsets.symmetric(vertical: 30,horizontal: 15 )
            ),
            onPressed: () {
           
              print('Host Game button pressed');
            },
            child:  Text(AppStrings.hostGame,style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:  AppColors.kButtonBackgroundColor.withOpacity(0.2), 
              foregroundColor:  AppColors.kButtonBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: 30,horizontal: 15 )
            ),
            onPressed: () {
              
              print('Join Game button pressed');
            },
            child:  Text(AppStrings.joinGame,style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      ],
    );
  }
}