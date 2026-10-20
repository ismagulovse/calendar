import '../data/task_repo.dart';
import '../models/task.dart';
import '../models/task_options.dart';

class TodoState {
  final TaskRepo repo = TaskRepo();
  String search = '';
  String filter = 'Все';
  String category = 'Все категории';
  String sort = 'Сначала новые';

  List<Task> get tasks => repo.tasks;

  List<Task> get visible {
    final List<Task> list = [];
    final text = search.trim().toLowerCase();

    for (final task in tasks) {
      if (!task.title.toLowerCase().contains(text)) {
        continue;
      }
      if (filter == 'Активные' && task.done) {
        continue;
      }
      if (filter == 'Выполненные' && !task.done) {
        continue;
      }
      if (category != 'Все категории' && task.category != category) {
        continue;
      }
      list.add(task);
    }

    list.sort(compare);
    return list;
  }

  int compare(Task a, Task b) {
    int result;
    if (sort == 'По приоритету') {
      result = b.rank.compareTo(a.rank);
    } else if (sort == 'По категории') {
      result = categories
          .indexOf(a.category)
          .compareTo(categories.indexOf(b.category));
    } else if (sort == 'Сначала старые') {
      result = a.date.compareTo(b.date);
    } else {
      result = b.date.compareTo(a.date);
    }
    if (result == 0) {
      return tasks.indexOf(a).compareTo(tasks.indexOf(b));
    }
    return result;
  }
  void add(String title, {String category = 'Учеба', int rank = 1}) {
    repo.add(
      Task(title: title, date: DateTime.now(), category: category, rank: rank),
    );
  }

  void edit(Task task, String title, {String? category, int? rank}) {
    repo.edit(task, title, category: category, rank: rank);
  }

  void toggle(Task task) {
    repo.toggle(task);
  }

  void remove(Task task) {
    repo.remove(task);
  }
}
