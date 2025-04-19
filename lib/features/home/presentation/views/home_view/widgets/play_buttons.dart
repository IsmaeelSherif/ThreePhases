import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_phases/core/utils/app_colors.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/features/home/data/models/game_model.dart';
import 'dart:math';

import 'package:three_phases/features/home/presentation/views/host_game_view/host_game_view.dart';

class PlayButtons extends StatelessWidget {
  const PlayButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kButtonBackgroundColor.withOpacity(0.2),
              foregroundColor: AppColors.kButtonBackgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15)
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HostGameView())),
            child: Text(AppStrings.hostGame, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kButtonBackgroundColor.withOpacity(0.2),
              foregroundColor: AppColors.kButtonBackgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15)
            ),
            onPressed: () => _showJoinGameDialog(context),
            child: Text(AppStrings.joinGame, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      ],
    );
  }

  Future<void> _showJoinGameDialog(BuildContext context) async {
    final codeController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Game'),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            hintText: 'Enter 6-digit game code',
          ),
          maxLength: 6,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final code = codeController.text;
              if (code.length != 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a 6-digit code')),
                );
                return;
              }

              final gameDoc = await FirebaseFirestore.instance
                  .collection('games')
                  .doc(code)
                  .get();

              if (!gameDoc.exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Game not found')),
                );
                return;
              }

              Navigator.pop(context);
              // TODO: Navigate to game screen with the game data
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }


    Future<void> _showHostGameDialog(BuildContext context) async {
    Set<GameCategory> selectedCategories = Set.from(GameCategory.values);
    GameLanguage selectedLanguage = GameLanguage.english;
    final width=MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Host Game'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Categories:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 200, 
                  width: width * 0.8,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    children: GameCategory.values.map(
                      (category) => CheckboxListTile(
                        dense: true,
                        title: Text(category.name),
                        value: selectedCategories.contains(category),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value ?? false) {
                              selectedCategories.add(category);
                            } else {
                              if (selectedCategories.length > 1) {
                                selectedCategories.remove(category);
                              }
                            }
                          });
                        },
                      ),
                    ).toList(),
                  ),
               
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Language:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<GameLanguage>(
                        value: selectedLanguage,
                        isExpanded: true,
                        items: GameLanguage.values
                            .map((l) => DropdownMenuItem(
                                  value: l,
                                  child: Text(l.name),
                                ))
                            .toList(),
                        onChanged: (GameLanguage? value) {
                          if (value != null) {
                            setState(() => selectedLanguage = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Generate a random 6-digit code
                final random = Random();
                final code = (100000 + random.nextInt(900000)).toString();

                final game = GameModel(
                  code: code,
                  categories: selectedCategories.toList(),
                  language: selectedLanguage,
                );

                await FirebaseFirestore.instance
                    .collection('games')
                    .doc(code)
                    .set(game.toMap());

                Navigator.pop(context);
                // TODO: Navigate to game screen with the game data
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Game created with code: $code')),
                );
              },
              child: const Text('Host'),
            ),
          ],
        ),
      ),
    );
  }

}