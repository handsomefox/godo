import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/widgets/task_list_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getChildrenTasks(),
      shrinkWrap: true,
    );
  }

  List<Widget> getChildrenTasks() {
    var list = tasks
        .map((task) => Container(
            margin: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: TaskListItem(task: task)))
        .toList();
    return list;
  }
}
