import 'package:flutter/material.dart';

import '../calendar_dates.dart';
import '../calendar_names.dart';
import '../state/calendar_state.dart';

class CalendarMonth extends StatelessWidget {
  final CalendarState state;

  const CalendarMonth({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        final month = state.currentMonth;
        final days = getCalendarDays(month);
        final today = DateTime.now();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: state.previousMonth,
                  tooltip: 'Предыдущий месяц',
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: month.month,
                          items: [
                            for (int i = 0; i < monthNames.length; i++)
                              DropdownMenuItem(
                                value: i + 1,
                                child: Text(monthNames[i]),
                              ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              state.changeMonth(month.year, value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: month.year,
                          items: [
                            for (
                              int year = month.year - 100;
                              year <= month.year + 100;
                              year++
                            )
                              DropdownMenuItem(
                                value: year,
                                child: Text('$year'),
                              ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              state.changeMonth(value, month.month);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: state.nextMonth,
                  tooltip: 'Следующий месяц',
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            Row(
              children: [
                for (final day in weekDays)
                  Expanded(child: Center(child: Text(day))),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: 48,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final date = days[index];
                final isCurrentMonth =
                    date.year == month.year && date.month == month.month;
                final isSelected = state.isSameDay(date, state.selectedDate);
                final isToday = state.isSameDay(date, today);

                return InkWell(
                  onTap: () => state.selectDate(date),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade100 : null,
                      border: isToday ? Border.all(color: Colors.blue) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isCurrentMonth ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
