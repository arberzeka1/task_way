import 'package:task_way/models/task_model.dart';

abstract class TasksEvent {
  const TasksEvent();
}

class UpdateTaskEvent extends TasksEvent {
  final Task updatedTask;
  final bool? fromUpdate;

  const UpdateTaskEvent({required this.updatedTask, this.fromUpdate = false});

  List<Object?> get props => [updatedTask];
}

class AddTaskEvent extends TasksEvent {
  final String taskId;
  final Task updatedTask;

  const AddTaskEvent({required this.taskId, required this.updatedTask});

  List<Object?> get props => [taskId, updatedTask];
}

class GetTaskEvent extends TasksEvent {
  const GetTaskEvent();
  List<Object?> get props => [];
}

class LoadingEvent extends TasksEvent {
  const LoadingEvent();
  List<Object?> get props => [];
}

class DeleteTaskEvent extends TasksEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  List<Object> get props => [taskId];
}

class DeleteCommentEvent extends TasksEvent {
  final String taskId;
  final String commentId;

  const DeleteCommentEvent(this.taskId, this.commentId);

  List<Object> get props => [taskId, commentId];
}

class StartTimeTrackerEvent extends TasksEvent {
  final String taskId;
  final int? previousValue;

  StartTimeTrackerEvent(this.taskId, this.previousValue);
}

class StopTimeTrackerEvent extends TasksEvent {
  final String taskId;
  final Task updatedTask;

  StopTimeTrackerEvent(this.taskId, this.updatedTask);
}

class UpdateTimeTrackerEvent extends TasksEvent {
  final String taskId;
  final Duration elapsedTime;

  UpdateTimeTrackerEvent(this.taskId, this.elapsedTime);
}
