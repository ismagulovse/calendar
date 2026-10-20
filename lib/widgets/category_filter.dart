import 'package:flutter/material.dart';

import '../models/task_options.dart';

class CategoryFilter extends StatelessWidget {
  final String category;
  final ValueChanged<String> onChange;

  const CategoryFilter({
    super.key,
    required this.category,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        ChoiceChip(
          label: const Text('Все категории'),
          selected: category == 'Все категории',
          selectedColor: const Color(0xFFE8EFFA),
          onSelected: (value) {
            onChange('Все категории');
          },
        ),
        for (final name in categories)
          ChoiceChip(
            label: Text(name),
            selected: category == name,
            selectedColor: const Color(0xFFE8EFFA),
            onSelected: (value) {
              onChange(name);
            },
          ),
      ],
    );
  }
}