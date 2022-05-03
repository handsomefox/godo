import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';

class TaskModel with ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      name: "Do the dishes",
      desc: "Please, wash them carefully",
      subtasks: ["Open the door", "Close the door"],
      due: DateTime.now(),
    )
  ];
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  UnmodifiableListView<Task> get completed =>
      UnmodifiableListView(_tasks.where((element) => !element.completed));

  UnmodifiableListView<Task> get uncompleted =>
      UnmodifiableListView(_tasks.where((element) => element.completed));

  void add(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void remove(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void toggle(Task task) {
    var index = _tasks.indexOf(task);
    _tasks[index].toggleCompleted();
    notifyListeners();
  }
}
