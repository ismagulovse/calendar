class Task {
  String title;
  DateTime date;
  DateTime? scheduledDate;
  bool done;
  String category;
  int rank;

  Task({
    required this.title,
    required this.date,
    this.scheduledDate,
    this.done = false,
    this.category = 'Учеба',
    this.rank = 1,
  });
}
