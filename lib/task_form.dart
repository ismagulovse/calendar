import 'package:flutter/material.dart';

import 'models/task.dart';
import 'models/task_options.dart';
import 'state/calendar_state.dart';
import 'widgets/calendar_month.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final DateTime? initialDate;

  const TaskForm({super.key, this.task, this.initialDate});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  String category = 'Учеба';
  int rank = 1;
  bool hasDate = false;
  DateTime scheduledDate = DateTime.now();
  final CalendarState datePickerState = CalendarState();

  @override
  void initState() {
    super.initState();
    title.text = widget.task?.title ?? '';
    category = widget.task?.category ?? 'Учеба';
    rank = widget.task?.rank ?? 1;
    final date = widget.task?.scheduledDate ?? widget.initialDate;
    hasDate = date != null;
    scheduledDate = date ?? DateTime.now();
  }

  Future<void> chooseDate() async {
    datePickerState.currentMonth = scheduledDate;
    datePickerState.selectedDate = scheduledDate;

    final date = await showDialog<DateTime>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите дату'),
        contentPadding: const EdgeInsets.all(8),
        content: SizedBox(
          width: 350,
          child: SingleChildScrollView(
            child: CalendarMonth(state: datePickerState),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, datePickerState.selectedDate),
            child: const Text('Выбрать'),
          ),
        ],
      ),
    );
    if (!mounted || date == null) return;
    setState(() {
      scheduledDate = DateTime(
        date.year,
        date.month,
        date.day,
        scheduledDate.hour,
        scheduledDate.minute,
      );
    });
  }

  Future<void> chooseTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(scheduledDate),
    );
    if (!mounted || time == null) return;
    setState(() {
      scheduledDate = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        time.hour,
        time.minute,
      );
    });
  }

  void save() {
    if (formKey.currentState!.validate()) {
      final task = Task(
        title: title.text.trim(),
        date: widget.task?.date ?? DateTime.now(),
        done: widget.task?.done ?? false,
        category: category,
        rank: rank,
        scheduledDate: hasDate ? scheduledDate : null,
      );
      Navigator.pop(context, task);
    }
  }

  @override
  void dispose() {
    datePickerState.dispose();
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Новая задача' : 'Изменить задачу'),
        backgroundColor: const Color(0xFFF5F7FA),
        foregroundColor: const Color(0xFF163F73),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: FilledButton.icon(
            onPressed: save,
            icon: const Icon(Icons.check),
            label: const Text('Сохранить'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF163F73),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF163F73),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        'Новая задача',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Название, категория и важность задачи',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: title,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Название',
                    hintText: 'Например, прочитать конспект',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите название задачи';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Поставить дату'),
                  value: hasDate,
                  onChanged: (value) {
                    setState(() {
                      hasDate = value ?? false;
                    });
                  },
                ),
                if (hasDate) ...[
                  OutlinedButton.icon(
                    onPressed: chooseDate,
                  
                    label: Text(
                      'Дата: ${scheduledDate.day}.${scheduledDate.month}.${scheduledDate.year}',
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: chooseTime,
                  
                    label: Text(
                      'Время начала: ${TimeOfDay.fromDateTime(scheduledDate).format(context)}',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                const Text(
                  'Категория',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163F73),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final name in categories)
                      ChoiceChip(
                        label: Text(name),
                        selected: category == name,
                        selectedColor: const Color(0xFFE8EFFA),
                        onSelected: (value) {
                          setState(() {
                            category = name;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Приоритет',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163F73),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (int i = 0; i < priorities.length; i++)
                      ChoiceChip(
                        label: Text(priorities[i]),
                        selected: rank == i,
                        selectedColor: const Color(0xFFE8EFFA),
                        onSelected: (value) {
                          setState(() {
                            rank = i;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
