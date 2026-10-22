import 'package:flutter/material.dart';

class AddTaskButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddTaskButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: onPressed,
      tooltip: 'Добавить задачу',
      backgroundColor: const Color(0xFF163F73),
      foregroundColor: Colors.white,
      child: const Icon(Icons.add),
    );
  }
}
