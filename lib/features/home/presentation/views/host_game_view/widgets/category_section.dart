import 'package:flutter/material.dart';
import 'package:three_phases/core/enums/game_enums.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_colors.dart';

class CategoryMultiSelectDropdown extends StatefulWidget {
  const CategoryMultiSelectDropdown({super.key, required this.game});
  final GameModel game;

  @override
  State<CategoryMultiSelectDropdown> createState() => _CategoryMultiSelectDropdownState();
}

class _CategoryMultiSelectDropdownState extends State<CategoryMultiSelectDropdown> {
  void _openMultiSelectDialog() async {
    final selected = await showDialog<Set<GameCategory>>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final tempSelected = widget.game.categories.toSet();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select Categories"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: GameCategory.values.map((category) {
                    return CheckboxListTile(
                      value: tempSelected.contains(category),
                      title: Text(category.value),
                      onChanged: (bool? checked) {
                        setState(() {
                          checked == true
                              ? tempSelected.add(category)
                              : tempSelected.remove(category);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text("CANCEL"),
                  onPressed: () => Navigator.pop(context, widget.game.categories.toSet()),
                ),
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context, tempSelected),
                ),
              ],
            );
          }
        );
      },
    );

    if (selected != null) {
      setState(() {
        widget.game.categories
          ..clear()
          ..addAll(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedText = widget.game.categories.isEmpty
        ? 'Select Categories'
        : widget.game.categories.map((e) => e.value).join(', ');

    return InkWell(
      onTap: _openMultiSelectDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.kButtonBackgroundColorTransparent,
          border: Border.all(color: AppColors.kWhite),
        ),
        child: Text(selectedText,style: Theme.of(context).textTheme.bodyLarge,)),
    );
  }
}
