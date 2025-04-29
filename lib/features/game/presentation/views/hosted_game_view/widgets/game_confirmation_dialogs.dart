import 'package:flutter/material.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/core/utils/app_strings.dart';
import 'package:three_phases/core/widgets/snack_bar.dart';

class GameConfirmationDialogs {
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required GameModel game,
    required VoidCallback onConfirm,
    String title = 'Are you sure?',
    String content = 'This action cannot be undone',
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  static Future<void> showPasswordConfirmationDialog({
    required BuildContext context,
    required GameModel game,
    required VoidCallback onConfirm,
    String title = 'Enter Password',
    String content = 'This action requires password verification',
  }) {
    final TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(content),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLength: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '6-digit Password',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text == game.password) {
                Navigator.pop(context);
                onConfirm();
              }else{
                showSnackBar(context, message: AppStrings.wrongPassword);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

}