class Task {
  String title;
  DateTime date;
  bool done;
  String category;
  int rank;

  Task({
    required this.title,
    required this.date,
    this.done = false,
    this.category = 'Учеба',
    this.rank = 1,
  });
}
