import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/app_cupit/app_cubit.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/gradient_scaffold.dart';
import 'package:three_phases/features/home/presentation/views/home_view/widgets/play_buttons.dart';
import 'package:three_phases/core/widgets/rainbow_title.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    return  GradientScaffold(
      appBar: AppBar(
            backgroundColor: Colors.transparent, // Make AppBar transparent
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.language, color: Colors.white),
                tooltip: 'Change Language', 
                onPressed: () {
                  context.read<AppCubit>().changeLanguage(
                    context.read<AppCubit>().currentLanguage == GameLanguage.english
                        ? GameLanguage.arabic
                        : GameLanguage.english,
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: height *0.05),
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 const RainbowTitle(),
                  SizedBox(height: height *0.15,),
                   PlayButtons()
                ]
              ),
            ),
          ),);
  }
}

