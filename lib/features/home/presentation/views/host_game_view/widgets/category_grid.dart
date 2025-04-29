import 'package:flutter/material.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/widgets/custtom_button.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key, required this.game});
  final GameModel game;
  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: GameCategory.values
          .map(
            (category) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: CusttomButton(
                onPressed: () {
                  setState(() {
                    if (widget.game.categories.contains(category)) {
                      widget.game.categories.remove(category);
                    } else {
                      widget.game.categories.add(category);
                    }
                  });
                },
                text: category.value,
                isSelected: widget.game.categories.contains(category),
              ),
            ),
          )
          .toList(),
    );
  }
}
