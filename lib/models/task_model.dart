import 'package:flutter/material.dart';

import 'comment_model.dart';

class Task {
  final String? taskId;
  final String? title;
  final String? description;
  final Status? status;
  final TaskType? taskType;
  final List<CommentModel>? comments;
  late final int? timeSpent;
  final DateTime? completionDate;
  bool isTracking;

  Task({
    this.taskId,
    required this.title,
    required this.description,
    this.status,
    this.taskType,
    this.comments,
    this.timeSpent,
    this.completionDate,
    this.isTracking = false,
  });
  void updateTimeSpent(int time) {
    timeSpent = time;
  }

  Task copyWith({
    String? taskId,
    String? title,
    String? description,
    DateTime? completionDate,
    Status? status,
    TaskType? taskType,
    int? timeSpent,
    List<CommentModel>? comments,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      completionDate: completionDate ?? this.completionDate,
      taskType: taskType ?? this.taskType,
      timeSpent: timeSpent ?? this.timeSpent,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'title': title ?? '',
      'description': description,
      'status': status?.statusName,
      'taskType': taskType?.taskName,
      'completionDate': completionDate?.toIso8601String(),
      'comments': comments?.map((comment) => comment.toMap()).toList() ?? [],
      'timeSpent': timeSpent ?? 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, List<CommentModel>? comments) {
    DateTime? completionDate;
    if (map['completionDate'] != null) {
      completionDate = DateTime.parse(map['completionDate']);
    }

    return Task(
      taskId: map['taskId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: stringToStatus(map['status'] ?? 'todo'),
      taskType: stringToTaskType(map['taskType'] ?? 'taskType'),
      comments: comments ?? [],
      timeSpent: map['timeSpent'] ?? 0,
      completionDate: completionDate,
    );
  }
}

enum Status {
  todo,
  inProgress,
  done,
  empty;

  String get statusName {
    switch (this) {
      case Status.todo:
        return 'Todo';
      case Status.inProgress:
        return 'InProgress';
      case Status.done:
        return 'Done';
      case Status.empty:
        return '';
      default:
        return '';
    }
  }
}

enum TaskType {
  task,
  story,
  bug;

  String get taskName {
    switch (this) {
      case TaskType.task:
        return 'Task';
      case TaskType.story:
        return 'Story';
      case TaskType.bug:
        return 'Bug';

      default:
        return 'Task';
    }
  }
}

String statusToString(Status status) {
  return status.statusName;
}

String taskToString(TaskType taskType) {
  return taskType.taskName;
}

Status stringToStatus(String status) {
  switch (status) {
    case 'Todo':
      return Status.todo;
    case 'InProgress':
      return Status.inProgress;
    case 'Done':
      return Status.done;
    case '':
      return Status.empty;
    default:
      throw Exception('Invalid status value');
  }
}

TaskType stringToTaskType(String taskType) {
  switch (taskType) {
    case 'Task':
      return TaskType.task;
    case 'Story':
      return TaskType.story;
    case 'Bug':
      return TaskType.bug;
    default:
      throw Exception('Invalid status value');
  }
}

Color taskToColor(TaskType? status) {
  switch (status) {
    case TaskType.task:
      return Colors.blue;
    case TaskType.story:
      return Colors.green;
    case TaskType.bug:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

IconData taskToIcon(TaskType? status) {
  switch (status) {
    case TaskType.task:
      return Icons.check;
    case TaskType.story:
      return Icons.bookmark;
    case TaskType.bug:
      return Icons.circle;
    default:
      return Icons.macro_off;
  }
}
