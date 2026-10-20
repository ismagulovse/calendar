import 'package:flutter/material.dart';

import 'models/task.dart';
import 'models/task_options.dart';

class TaskForm extends StatefulWidget {
  final Task? task;

  const TaskForm({super.key, this.task});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  String category = 'Учеба';
  int rank = 1;

  @override
  void initState() {
    super.initState();
    title.text = widget.task?.title ?? '';
    category = widget.task?.category ?? 'Учеба';
    rank = widget.task?.rank ?? 1;
  }

  void save() {
    if (formKey.currentState!.validate()) {
      final task = Task(
        title: title.text.trim(),
        date: widget.task?.date ?? DateTime.now(),
        done: widget.task?.done ?? false,
        category: category,
        rank: rank,
      );
      Navigator.pop(context, task);
    }
  }

  @override
  void dispose() {
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
