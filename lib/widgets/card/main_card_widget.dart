import 'package:flutter/material.dart';
import 'package:task_way/models/task_model.dart';
import 'package:task_way/ui/main_view.dart';

class MainCardWidget extends StatelessWidget {
  final Widget leadingWidget;
  final Task? task;
  final List<PopupMenuItem<DropDownType>> itemList;
  final Function(DropDownType)? onSelectMenuItem;
  final Function()? onTap;
  final bool isPlaying;
  final Widget timeWidget;

  const MainCardWidget({
    super.key,
    required this.leadingWidget,
    required this.task,
    required this.itemList,
    this.onSelectMenuItem,
    this.onTap,
    this.isPlaying = false,
    required this.timeWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          onTap: onTap,
          leading: leadingWidget,
          title: Text(task?.title ?? ''),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Text(task?.description ?? ''),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(statusToString(task?.status ?? Status.empty)),
                  ),
                ),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              timeWidget,
              const SizedBox(
                width: 10,
              ),
              PopupMenuButton<DropDownType>(
                  onSelected: onSelectMenuItem,
                  itemBuilder: (BuildContext context) {
                    return itemList;
                  }),
            ],
          )),
    );
  }
}
