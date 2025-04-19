import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:three_phases/core/app_cupit/app_cubit.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/utils/app_colors.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  final Set<GameCategory> gameCategories = Set.from(GameCategory.values);
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: GameCategory.values
          .map(
            (category) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (gameCategories.contains(category)) {
                      gameCategories.remove(category);
                    } else {
                      gameCategories.add(category);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      gameCategories.contains(category) ? AppColors.kPrimaryColor : AppColors.kSeconderyTextColor,
                  foregroundColor: gameCategories.contains(category) ? AppColors.kPrimaryColor : AppColors.kSeconderyTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  category.getValue(cubit.currentLanguage),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
