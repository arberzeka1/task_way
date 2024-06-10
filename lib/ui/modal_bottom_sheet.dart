import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_way/bloc/tasks_bloc.dart';
import 'package:task_way/bloc/tasks_event.dart';
import 'package:task_way/models/comment_model.dart';
import 'package:task_way/models/task_model.dart';
import 'package:uuid/uuid.dart';

class ModalBottomSheet extends StatefulWidget {
  final Task? task;
  final bool? fromUpdate;
  const ModalBottomSheet({super.key, this.task, this.fromUpdate = false});

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  late TaskType _selectedOption;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool readOnly = true;
  List<CommentModel> commentList = [];
  var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');

  @override
  void initState() {
    _titleController.text = widget.task?.title ?? '';
    _descriptionController.text = widget.task?.description ?? '';
    _selectedOption = widget.task?.taskType ?? TaskType.bug;
    commentList = widget.task?.comments ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<TaskType>(
                value: _selectedOption,
                onChanged: (TaskType? newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                },
                items: <TaskType>[TaskType.task, TaskType.story, TaskType.bug]
                    .map<DropdownMenuItem<TaskType>>((TaskType value) {
                  return DropdownMenuItem<TaskType>(
                    value: value,
                    child: Text(
                      taskToString(value),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Title'),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Add your title...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Description'),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Add your description...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (commentList.isNotEmpty) const Text('Comments'),
              if (commentList.isNotEmpty)
                Column(
                  children: commentList
                      .map((comment) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        comment.description ?? '',
                                        textAlign: TextAlign.start,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            commentList.remove(comment);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                )),
                          ))
                      .toList(),
                ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add your Comments...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    commentList.add(CommentModel(
                        commentId: const Uuid().v4(),
                        description: _commentController.text));
                  });
                  _commentController.clear();
                },
                child: const Text('Add Comment'),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Text(
                    'Time Spent',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.task?.timeSpent != null
                      ? "${widget.task?.timeSpent.toString()}"
                      : '-'),
                ],
              ),
              const SizedBox(height: 40),
              if (widget.task?.status == Status.done)
                Row(
                  children: [
                    const Text(
                      'Completed Time',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${widget.task?.completionDate}'),
                  ],
                ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<TaskBloc>(context).add(
                    UpdateTaskEvent(
                      updatedTask: Task(
                        taskId: widget.task?.taskId,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        status: Status.todo,
                        taskType: _selectedOption,
                        comments: commentList,
                        timeSpent: widget.task?.timeSpent ?? 0,
                      ),
                      fromUpdate: widget.fromUpdate,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.fromUpdate == true
                            ? 'Update Task'
                            : 'Create Task',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
