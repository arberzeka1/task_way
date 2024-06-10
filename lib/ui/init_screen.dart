import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_way/bloc/tasks_bloc.dart';
import 'package:task_way/bloc/tasks_event.dart';
import 'package:task_way/helper_functions/helper_functions.dart';
import 'package:task_way/models/navigation_bar_model.dart';
import 'package:task_way/ui/screens/done_screen.dart';
import 'package:task_way/ui/screens/progress_screen.dart';
import 'package:task_way/ui/screens/todo_screen.dart';
import 'package:task_way/widgets/navigation_bar.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int _selectedIndex = 0;
  final Map<String, PopsoNavigationBarModel> _tabs = {
    "navbarHome": PopsoNavigationBarModel(
      icon: Icons.receipt_long_outlined,
      iconSelected: Icons.receipt_long,
      text: "To Do",
      key: 'todo',
    ),
    "navbarCreditcard": PopsoNavigationBarModel(
      icon: Icons.construction_outlined,
      iconSelected: Icons.construction,
      text: "In Progress",
      key: 'progress',
    ),
    "navbarPagamenti": PopsoNavigationBarModel(
      icon: Icons.check_circle_outline,
      iconSelected: Icons.check_circle,
      text: "Done",
      key: 'done',
    ),
  };

  static const List<Widget> _widgetOptions = <Widget>[
    TodoScreen(),
    ProgressScreen(),
    DoneScreen(),
  ];

  @override
  void initState() {
    BlocProvider.of<TaskBloc>(context).add(const GetTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Way'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: MainNavigationBar(
        items: _tabs.values.toList(),
        currentIndex: _selectedIndex,
        onChanged: (index, item) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HelperFunction().createTask(context, null, null);
          FirebaseAnalytics.instance.logEvent(name: 'create_task');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
