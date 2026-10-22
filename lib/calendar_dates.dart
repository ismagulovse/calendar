List<DateTime> getCalendarDays(DateTime month) {

  DateTime firstDay = DateTime(month.year, month.month, 1);

  int daysBefore = firstDay.weekday - 1;

  DateTime startDate = DateTime(
    firstDay.year,
    firstDay.month,
    1 - daysBefore,
  );

  List<DateTime> days = [];

  for (int i = 0; i < 42; i++) {
    DateTime date = DateTime(
      startDate.year,
      startDate.month,
      startDate.day + i,
    );

    days.add(date);
  }

  return days;
}
