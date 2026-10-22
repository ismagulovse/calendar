import 'package:flutter/material.dart';

import 'models/task.dart';
import 'state/calendar_state.dart';
import 'state/todo_state.dart';
import 'task_form.dart';
import 'widgets/add_task_button.dart';
import 'widgets/calendar_month.dart';
import 'widgets/task_card.dart';

class CalendarScreen extends StatefulWidget {
  final TodoState taskState;

  const CalendarScreen({super.key, required this.taskState});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarState calendarState = CalendarState();

  Future<void> openTaskForm({Task? task}) async {
    final data = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskForm(
          task: task,
          initialDate: task == null ? calendarState.selectedDate : null,
        ),
      ),
    );
    if (!mounted || data == null) return;

    if (task == null) {
      widget.taskState.add(
        data.title,
        category: data.category,
        rank: data.rank,
        scheduledDate: data.scheduledDate,
      );
    } else {
      widget.taskState.edit(
        task,
        data.title,
        category: data.category,
        rank: data.rank,
        scheduledDate: data.scheduledDate,
      );
    }
  }

  @override
  void dispose() {
    calendarState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddTaskButton(onPressed: () => openTaskForm()),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: calendarState,
          builder: (context, child) {
            final day = calendarState.selectedDate;
            final tasks = widget.taskState.tasksForDay(day);

            return ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              children: [
                CalendarMonth(state: calendarState),
                const SizedBox(height: 16),
                Text(
                  'Задачи на ${day.day}.${day.month}.${day.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (tasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('На этот день задач нет'),
                  ),
                for (final task in tasks)
                  TaskCard(
                    task: task,
                    onEdit: () => openTaskForm(task: task),
                    onToggle: () => widget.taskState.toggle(task),
                    onRemove: () => widget.taskState.remove(task),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
