import 'package:equatable/equatable.dart';
import 'package:task_way/models/task_model.dart';

class TasksState extends Equatable {
  const TasksState(this.taskListTodo, this.taskListInProgress,
      this.taskListDone, this.firstModel, this.isLoading,
      {this.error});

  final List<Task> taskListTodo;
  final List<Task> taskListInProgress;
  final List<Task> taskListDone;
  final Task? firstModel;
  final bool isLoading;
  final String? error;

  @override
  List<Object?> get props => [
        taskListTodo,
        taskListInProgress,
        taskListDone,
        firstModel,
        isLoading,
        error
      ];

  TasksState copyWith({
    List<Task>? taskListTodo,
    List<Task>? taskListInProgress,
    List<Task>? taskListDone,
    Task? firstModel,
    bool? isLoading,
  }) {
    return TasksState(
      taskListTodo ?? this.taskListTodo,
      taskListInProgress ?? this.taskListInProgress,
      taskListDone ?? this.taskListDone,
      firstModel ?? this.firstModel,
      isLoading ?? this.isLoading,
    );
  }
}

class TimeTrackerState extends TasksState {
  final String taskId;
  final Duration elapsedTime;

  const TimeTrackerState({
    required List<Task> taskListTodo,
    required List<Task> taskListInProgress,
    required List<Task> taskListDone,
    required Task? firstModel,
    required bool isLoading,
    required this.taskId,
    required this.elapsedTime,
  }) : super(
          taskListTodo,
          taskListInProgress,
          taskListDone,
          firstModel,
          isLoading,
        );

  @override
  List<Object?> get props => super.props..addAll([taskId, elapsedTime]);
}
