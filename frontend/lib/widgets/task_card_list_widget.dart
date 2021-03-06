import 'package:flutter/material.dart';
import 'package:godo/models/task_model.dart';
import 'package:godo/pages/edit_task_page.dart';
import 'package:godo/services/api_service.dart';
import 'package:godo/widgets/task_card_widget.dart';

class TaskCardListWidget extends StatelessWidget {
  const TaskCardListWidget({Key? key, required this.tasks, required this.user})
      : super(key: key);
  final User? user;
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
                              isNew: false,
                              user: user,
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
