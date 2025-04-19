import 'package:flutter/material.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/utils/app_colors.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  Set<GameCategory> selectedCategories = Set.from(GameCategory.values);
  GameLanguage selectedLanguage = GameLanguage.english;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3,
      children:
          GameCategory.values
              .map(
                (category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (selectedCategories.contains(category)) {
                          selectedCategories.remove(category);
                        } else {
                          selectedCategories.add(category);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedCategories.contains(category) ?  AppColors.kPrimaryColor : AppColors.kSeconderyTextColor ,
                      foregroundColor: selectedCategories.contains(category) ? AppColors.kPrimaryColor : AppColors.kSeconderyTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      category.value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
