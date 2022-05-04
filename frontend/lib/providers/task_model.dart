import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/auth.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/task.dart';

class TaskModel with ChangeNotifier {
  User? user;
  TaskModel();
  TaskModel.fromUser(BuildContext context, this.user) {
    load(context, user!).then((value) => notifyListeners());
  }

  List<Task> _tasks = [
    Task(
      name: "Greetings!",
      desc:
          "This is an application for managing your tasks! To continue, please register or log in.",
      subtasks: ["Press the veritcal menu", "Press register or log in"],
      due: DateTime.now(),
    )
  ];
  UnmodifiableListView<Task> getTasks(BuildContext context) {
    return UnmodifiableListView(_tasks);
  }

  UnmodifiableListView<Task> getFilteredTasks(
      BuildContext context, String filter) {
    List<Task> list = [];

    for (var item in _tasks) {
      if (item.name.containsIgnoreCase(filter) ||
          item.desc.containsIgnoreCase(filter)) {
        list.add(item);
      }
    }

    return UnmodifiableListView(list);
  }

  Future<void> load(BuildContext context, User user) async {
    _tasks = await user.getTasks(context);
  }

  void add(Task task, User? user) {
    _tasks.add(task);
    var api = BaseApi();
    if (user != null) {
      api.addTask(task, user).then(
            (value) => {updateIndex(value, task)},
          );
    } else {
      notifyListeners();
    }
  }

  void updateIndex(http.Response response, Task task) {
    var decoded = jsonDecode(response.body);
    var id = decoded['tasks'][0]['id'];

    var index = _tasks.indexOf(task);
    _tasks.elementAt(index).id = id;

    notifyListeners();
  }

  void remove(Task task) {
    _tasks.remove(task);

    if (user != null) {}
    notifyListeners();
  }

  void toggle(Task task) {
    var index = _tasks.indexOf(task);
    _tasks[index].toggleCompleted();
    notifyListeners();
  }
}

extension StringExtensions on String {
  bool containsIgnoreCase(String secondString) =>
      toLowerCase().contains(secondString.toLowerCase());

  //bool isNotBlank() => this != null && this.isNotEmpty;
}
