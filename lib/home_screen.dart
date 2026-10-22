import 'package:flutter/material.dart';

import 'calendar_screen.dart';
import 'todoscreen.dart';
import 'state/todo_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  final TodoState taskState = TodoState();

  @override
  void dispose() {
    taskState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: taskState,
        builder: (context, child) {
          return IndexedStack(
            index: tab,
            children: [
              TodoScreen(state: taskState),
              CalendarScreen(taskState: taskState),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE8EFFA),
        onDestinationSelected: (value) {
          FocusScope.of(context).unfocus();
          setState(() {
            tab = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            label: 'Задачи',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Календарь',
          ),
        ],
      ),
    );
  }
}
