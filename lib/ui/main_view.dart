import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_way/bloc/tasks_bloc.dart';
import 'package:task_way/bloc/tasks_event.dart';
import 'package:task_way/helper_functions/helper_functions.dart';
import 'package:task_way/models/task_model.dart';
import 'package:task_way/widgets/card/task_card.dart';
import 'package:task_way/widgets/card/leading_card_widget.dart';
import 'package:task_way/widgets/card/main_card_widget.dart';

enum DropDownType {
  delete,
  edit,
  todo,
  progress,
  done,
}

class MainView extends StatelessWidget {
  final List<Task> taskList;
  const MainView({super.key, required this.taskList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        var task = taskList[index];
        return MainCardWidget(
          onTap: () {
            HelperFunction().createTask(context, task, true);
          },
          timeWidget: TaskCard(
            task: task,
          ),
          task: task,
          leadingWidget: LeadingCardWidget(
            icon: taskToIcon(task.taskType),
            color: taskToColor(task.taskType),
          ),
          onSelectMenuItem: (value) {
            switch (value) {
              case DropDownType.edit:
                return HelperFunction().createTask(context, task, true);
              case DropDownType.todo:
                BlocProvider.of<TaskBloc>(context).add(
                  UpdateTaskEvent(
                    updatedTask: task.copyWith(
                      status: Status.todo,
                    ),
                    fromUpdate: true,
                  ),
                );

              case DropDownType.progress:
                BlocProvider.of<TaskBloc>(context).add(
                  UpdateTaskEvent(
                    updatedTask: task.copyWith(
                      status: Status.inProgress,
                    ),
                    fromUpdate: true,
                  ),
                );
              case DropDownType.done:
                BlocProvider.of<TaskBloc>(context).add(
                  UpdateTaskEvent(
                    updatedTask: task.copyWith(
                        status: Status.done, completionDate: DateTime.now()),
                    fromUpdate: true,
                  ),
                );
              case DropDownType.delete:
                BlocProvider.of<TaskBloc>(context).add(
                  DeleteTaskEvent(
                    "${task.taskId}",
                  ),
                );
            }
          },
          itemList: [
            const PopupMenuItem<DropDownType>(
              value: DropDownType.delete,
              child: Text('Delete'),
            ),
            const PopupMenuItem<DropDownType>(
              value: DropDownType.edit,
              child: Text('Edit'),
            ),
            if (task.status != Status.todo)
              const PopupMenuItem<DropDownType>(
                value: DropDownType.todo,
                child: Text('Move in Todo'),
              ),
            if (task.status != Status.inProgress)
              const PopupMenuItem<DropDownType>(
                value: DropDownType.progress,
                child: Text('In Progress'),
              ),
            if (task.status != Status.done)
              const PopupMenuItem<DropDownType>(
                value: DropDownType.done,
                child: Text("Move to Done"),
              ),
          ],
        );
      },
    );
  }
}
