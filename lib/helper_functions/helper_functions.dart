import 'package:flutter/material.dart';
import 'package:task_way/models/task_model.dart';
import 'package:task_way/ui/modal_bottom_sheet.dart';

class HelperFunction {
  void createTask(BuildContext context, Task? task, bool? fromUpdate) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ModalBottomSheet(
          task: task,
          fromUpdate: fromUpdate,
        );
      },
    );
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}
