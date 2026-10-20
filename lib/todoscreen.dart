import 'package:flutter/material.dart';


import 'state/todo_state.dart';
import 'models/task.dart';
import 'models/task_options.dart';
import 'task_form.dart';
import 'widgets/task_card.dart';
import 'widgets/task_filter.dart';
import 'widgets/category_filter.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoState state = TodoState();

  Future<void> editTask(Task task) async {
    final Task? data = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => TaskForm(task: task)),
    );

    if (!mounted || data == null) {
      return;
    }

    setState(() {
      state.edit(task, data.title, category: data.category, rank: data.rank);
    });
  }

  void toggleTask(Task task) {
    setState(() {
      state.toggle(task);
    });
  }

  void removeTask(Task task) {
    setState(() {
      state.remove(task);
    });
  }

  Future<void> addTask() async {
    final Task? data = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => const TaskForm()),
    );

    if (!mounted || data == null) {
      return;
    }

    setState(() {
      state.add(data.title, category: data.category, rank: data.rank);
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = state.visible;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        tooltip: 'Добавить задачу',
        backgroundColor: const Color(0xFF163F73),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 80),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF163F73),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Icon(Icons.checklist, color: Colors.white, size: 32),
                    const SizedBox(height: 16),
                    const Text(
                      'Мои задачи',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Всего задач: ${state.tasks.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Поиск по названию',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    state.search = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TaskFilter(
                filter: state.filter,
                onChange: (value) {
                  setState(() {
                    state.filter = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Категория', style: TextStyle(color: Color(0xFF163F73), fontSize:16, fontWeight: FontWeight.bold ),),
              const SizedBox(height: 8),
              CategoryFilter(
                category: state.category,
                onChange: (value) {
                  setState(() {
                    state.category = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: state.sort,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Сортировка',
                  prefixIcon: const Icon(Icons.sort),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                items: [
                  for (final name in sorts)
                    DropdownMenuItem(value: name, child: Text(name)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      state.sort = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Список задач',
                style: TextStyle(
                  color: Color(0xFF163F73),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      state.tasks.isEmpty
                          ? 'Задач пока нет'
                          : 'Задачи не найдены',
                    ),
                  ),
                ),
              for (final task in list)
                TaskCard(
                  task: task,
                  onEdit: () => editTask(task),
                  onToggle: () => toggleTask(task),
                  onRemove: () => removeTask(task),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
