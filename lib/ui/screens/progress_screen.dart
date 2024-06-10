import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_way/bloc/tasks_bloc.dart';
import 'package:task_way/bloc/tasks_state.dart';
import 'package:task_way/ui/main_view.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      width: double.infinity,
      height: double.infinity,
      child: BlocBuilder<TaskBloc, TasksState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.taskListInProgress.isEmpty) {
            return const Center(
              child: Text('No Tickets in progress'),
            );
          }

          return MainView(
            taskList: state.taskListInProgress,
          );
        },
      ),
    );
  }
}
