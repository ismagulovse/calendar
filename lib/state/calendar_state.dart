import 'package:flutter/foundation.dart';

class CalendarState extends ChangeNotifier {
  DateTime currentMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  void previousMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    notifyListeners();
  }

  void nextMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
  void changeMonth(int year, int month) {
    currentMonth = DateTime(year, month, 1);
    notifyListeners();
  }
  
  bool isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
