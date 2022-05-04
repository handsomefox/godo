import 'package:flutter/material.dart';
import 'package:frontend/models/task_model.dart';
import 'package:frontend/pages/edit_task_page.dart';
import 'package:frontend/widgets/task_card_widget.dart';

class TaskCardListWidget extends StatelessWidget {
  const TaskCardListWidget({Key? key, required this.tasks}) : super(key: key);
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getChildrenTasks(context),
      shrinkWrap: true,
    );
  }

  List<Widget> getChildrenTasks(BuildContext context) {
    List<GestureDetector> list = tasks
        .map((Task task) => GestureDetector(
              onTapUp: (TapUpDetails details) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => EditTaskPage(
                              task: task,
                            )));
              },
              child: Container(
                  margin: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: TaskCardWidget(task: task)),
            ))
        .toList();
    return list;
  }
}
