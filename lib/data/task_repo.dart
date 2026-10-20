import '../models/task.dart';

class TaskRepo {
  final List<Task> tasks = [];

  void add(Task task) {
    tasks.add(task);
  }

  void edit(Task task, String title, {String? category, int? rank}) {
    task.title = title;
    if (category != null) {
      task.category = category;
    }
    if (rank != null) {
      task.rank = rank;
    }
  }

  void toggle(Task task) {
    task.done = !task.done;
  }

  void remove(Task task) {
    tasks.remove(task);
  }
}
