import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/task_options.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: task.done ? Colors.white : const Color(0xFFE8EFFA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onToggle,
            tooltip: task.done ? 'Вернуть в работу' : 'Отметить выполненной',
            icon: Icon(
              task.done ? Icons.check_circle : Icons.radio_button_unchecked,
            ),
            color: const Color(0xFF163F73),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: task.done ? Colors.grey : const Color(0xFF163F73),
                    decoration: task.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  task.category,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF163F73),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Приоритет: ${priorities[task.rank]}',
                  style: TextStyle(
                    fontSize: 13,
                    color: task.rank == 2
                        ? const Color(0xFF9A451A)
                        : Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Создана: ${task.date.day}.${task.date.month}.${task.date.year}',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  task.done ? 'Выполнена' : 'В работе',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Действия с задачей',
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'remove') {
                onRemove();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Изменить')),
              PopupMenuItem(value: 'remove', child: Text('Удалить')),
            ],
          ),
        ],
      ),
    );
  }
}
