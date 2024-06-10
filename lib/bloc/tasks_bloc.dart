import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_way/bloc/tasks_event.dart';
import 'package:task_way/bloc/tasks_state.dart';
import 'package:task_way/models/comment_model.dart';
import 'package:task_way/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskBloc extends Bloc<TasksEvent, TasksState> {
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;

  TaskBloc() : super(const TasksState([], [], [], null, false)) {
    on<UpdateTaskEvent>((event, emit) => updateCreateTask(event, emit));
    on<GetTaskEvent>((event, emit) => getHistoryData(event, emit));
    on<LoadingEvent>((event, emit) => emitLoadingState(emit, false));
    on<StartTimeTrackerEvent>((event, emit) => _startTimer(event, emit));
    on<StopTimeTrackerEvent>((event, emit) => _stopTimer(event, emit));
    on<UpdateTimeTrackerEvent>((event, emit) => _updateTimer(event, emit));
    on<DeleteTaskEvent>((event, emit) => _deleteTask(event, emit));
  }

  Future<void> _deleteTask(DeleteTaskEvent event, Emitter emit) async {
    try {
      emitLoadingState(emit, true);
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteTask');
      await callable.call({'taskId': event.taskId});
      await getHistoryData(const GetTaskEvent(), emit);
      emitLoadingState(emit, false);
    } on FirebaseFunctionsException catch (_) {
    } catch (e) {
      emitErrorState(emit, e);
    }
  }

  Future<void> updateCreateTask(UpdateTaskEvent event, Emitter emit) async {
    try {
      emitLoadingState(emit, true);

      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          event.fromUpdate == true ? 'updateTask' : 'saveToFirestore');

      final List<dynamic> commentsJson = event.updatedTask.comments
              ?.map((comment) => comment.toJson())
              .toList() ??
          [];

      await callable.call({
        'taskId': event.fromUpdate == true
            ? event.updatedTask.taskId
            : const Uuid().v4(),
        'title': event.updatedTask.title,
        'description': event.updatedTask.description,
        'status': statusToString(event.updatedTask.status ?? Status.todo),
        'comments': commentsJson,
        'taskType': taskToString(event.updatedTask.taskType ?? TaskType.task),
        'timeSpent': event.updatedTask.timeSpent,
        'completionDate': event.updatedTask.completionDate.toString(),
      });
      await getHistoryData(const GetTaskEvent(), emit);
      emitLoadingState(emit, false);
    } catch (e) {
      emitErrorState(emit, e);
      debugPrint('Error: $e');
    }
  }

  Future<void> getHistoryData(GetTaskEvent event, Emitter emit) async {
    try {
      emitLoadingState(emit, true);

      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getHistoryData');
      final HttpsCallableResult result = await callable.call();
      final List<dynamic> objectList = result.data as List<dynamic>;

      List<Task> taskListTodo = [];
      List<Task> taskListInProgress = [];
      List<Task> taskListDone = [];

      for (var item in objectList) {
        final Map<String, dynamic> taskMap = Map<String, dynamic>.from(item);

        final List<CommentModel> comments = (taskMap['comments']
                    as List<dynamic>?)
                ?.map((commentMap) =>
                    CommentModel.fromMap(Map<String, dynamic>.from(commentMap)))
                .toList() ??
            [];

        Task task = Task.fromMap(taskMap, comments);

        switch (task.status) {
          case Status.todo:
            taskListTodo.add(task);
            break;
          case Status.inProgress:
            taskListInProgress.add(task);
            break;
          case Status.done:
            taskListDone.add(task);
            break;
          default:
            [];
        }
      }

      final Task? lastHistory =
          taskListTodo.isNotEmpty ? taskListTodo.first : null;
      emit(TasksState(
          taskListTodo, taskListInProgress, taskListDone, lastHistory, false));
    } catch (e) {
      debugPrint('error $e');
      emitErrorState(emit, e);
    }
  }

  void _startTimer(StartTimeTrackerEvent event, Emitter<TasksState> emit) {
    _timer?.cancel();
    _elapsedTime = Duration(seconds: event.previousValue ?? 0);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime += const Duration(seconds: 1);
      add(UpdateTimeTrackerEvent(event.taskId, _elapsedTime));
    });

    emit(TimeTrackerState(
      taskListDone: state.taskListDone,
      taskListInProgress: state.taskListInProgress,
      taskListTodo: state.taskListTodo,
      firstModel: state.firstModel,
      isLoading: state.isLoading,
      taskId: event.taskId,
      elapsedTime: _elapsedTime,
    ));
  }

  Future<void> _stopTimer(
      StopTimeTrackerEvent event, Emitter<TasksState> emit) async {
    _timer?.cancel();

    Task updatedTask = event.updatedTask.copyWith(
      timeSpent: _elapsedTime.inSeconds,
    );

    emit(TimeTrackerState(
      taskListDone: state.taskListDone,
      taskListInProgress: state.taskListInProgress,
      taskListTodo: state.taskListTodo,
      firstModel: state.firstModel,
      isLoading: state.isLoading,
      taskId: event.taskId,
      elapsedTime: _elapsedTime,
    ));

    await updateCreateTask(
      UpdateTaskEvent(updatedTask: updatedTask, fromUpdate: true),
      emit,
    );
  }

  void _updateTimer(UpdateTimeTrackerEvent event, Emitter<TasksState> emit) {
    emit(TimeTrackerState(
      taskListDone: state.taskListDone,
      taskListInProgress: state.taskListInProgress,
      taskListTodo: state.taskListTodo,
      firstModel: state.firstModel,
      isLoading: state.isLoading,
      taskId: event.taskId,
      elapsedTime: event.elapsedTime,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void emitLoadingState(Emitter emit, bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }
}

void emitErrorState(Emitter emit, dynamic error) {
  emit(TasksState(const [], const [], const [], null, false,
      error: error.toString()));
}
