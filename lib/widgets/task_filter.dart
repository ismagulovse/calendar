import 'package:flutter/material.dart';

class TaskFilter extends StatelessWidget {
  final String filter;
  final ValueChanged<String> onChange;

  const TaskFilter({super.key, required this.filter, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final name in ['Все', 'Активные', 'Выполненные'])
          ChoiceChip(
            label: Text(name),
            selected: filter == name,
            selectedColor: const Color(0xFFE8EFFA),
            onSelected: (value) {
              onChange(name);
            },
          ),
      ],
    );
  }
}
