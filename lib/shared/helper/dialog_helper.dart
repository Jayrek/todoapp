import 'package:flutter/material.dart';

class DialogHelper {
  void showTodoAddedDialog({
    required BuildContext context,
    required VoidCallback onNo,
    required VoidCallback onYes,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Todo Added'),
            content: const Text('Would you like to add more todo?'),
            actions: [
              OutlinedButton(onPressed: onNo, child: const Text('No')),
              ElevatedButton(onPressed: onYes, child: const Text('Yes')),
            ],
          );
        });
  }
}
