import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_way/bloc/tasks_bloc.dart';
import 'package:task_way/bloc/tasks_event.dart';
import 'package:task_way/bloc/tasks_state.dart';
import 'package:task_way/helper_functions/helper_functions.dart';
import 'package:task_way/models/task_model.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TasksState>(
      builder: (context, state) {
        final isTracking =
            state is TimeTrackerState && state.taskId == widget.task.taskId;
        final isAnyTracking = state is TimeTrackerState;
        final elapsedTime =
            state is TimeTrackerState && state.taskId == widget.task.taskId
                ? state.elapsedTime.inSeconds
                : widget.task.timeSpent ?? 0;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Time: ${HelperFunction().formatTime(elapsedTime)}',
            ),
            IconButton(
              icon: Icon(isTracking ? Icons.pause : Icons.play_arrow),
              color: isAnyTracking && !isTracking ? Colors.grey : Colors.black,
              onPressed: isAnyTracking && !isTracking
                  ? null
                  : () {
                      if (isTracking) {
                        context.read<TaskBloc>().add(
                              StopTimeTrackerEvent(
                                  widget.task.taskId!, widget.task),
                            );
                      } else if (!isAnyTracking) {
                        context.read<TaskBloc>().add(
                              StartTimeTrackerEvent(widget.task.taskId!,
                                  widget.task.timeSpent ?? 0),
                            );
                      }
                    },
            ),
          ],
        );
      },
    );
  }
}
