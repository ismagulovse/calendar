import 'package:flutter/material.dart';

import 'calendar_screen.dart';
import 'todoscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: tab,
        children: const [TodoScreen(), CalendarScreen()],
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
