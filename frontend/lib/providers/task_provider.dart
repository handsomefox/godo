import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godo/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:godo/models/task_model.dart';

class TasksProvider with ChangeNotifier {
  TasksProvider();
  TasksProvider.fromUser(BuildContext context, this.user) {
    fetch(context, user!).then((void value) => notifyListeners());
  }

  User? user;

  List<Task> _tasks = <Task>[
    Task(
      name: 'Greetings!',
      desc:
          'This is an application for managing your tasks! To continue, please register or log in.',
      subtasks: [
        Subtask(name: 'Press vertical menu', completed: false),
        Subtask(name: 'Press log in', completed: false),
      ],
      due: DateTime.now(),
    )
  ];
  UnmodifiableListView<Task> tasks(BuildContext context) {
    return UnmodifiableListView<Task>(_tasks);
  }

  UnmodifiableListView<Task> filtered(BuildContext context, String filter) {
    List<Task> list = [];

    for (Task item in _tasks) {
      if (item.name.containsIgnoreCase(filter) ||
          item.desc.containsIgnoreCase(filter)) {
        list.add(item);
      }
    }
    return UnmodifiableListView<Task>(list);
  }

  Future<void> fetch(BuildContext context, User user) async {
    _tasks = await user.fetchTasks(context);
  }

  void add(Task task, User? user) {
    _tasks.add(task);
    BaseApiService api = BaseApiService();
    if (user != null) {
      api.insertTask(task, user).then(
            (http.Response value) => {
              (http.Response response, Task task) {
                var decoded = jsonDecode(response.body);
                String id = decoded['tasks'][0]['id'] as String;

                int index = _tasks.indexOf(task);
                _tasks.elementAt(index).id = id;

                notifyListeners();
              }(value, task)
            },
          );
    } else {
      notifyListeners();
    }
  }

  void update(Task task, User? user) {
    var index = _tasks.indexOf(task);
    _tasks[index] = task;
    BaseApiService api = BaseApiService();
    if (user != null) {
      api.updateTask(task, user).then(
            (http.Response value) => {
              (http.Response response, Task task) {
                // We don't need the response
                // Unless to check for errors :^)
                notifyListeners();
              }(value, task)
            },
          );
    } else {
      notifyListeners();
    }
  }

  void remove(Task task) {
    _tasks.remove(task);
    if (user != null) {
      BaseApiService api = BaseApiService();
      api
          .removeTask(task, user as User)
          .then((void value) => notifyListeners());
    } else {
      notifyListeners();
    }
  }

  void toggleCompleted(Task task) {
    int index = _tasks.indexOf(task);
    _tasks[index].toggleCompleted();
    notifyListeners();
  }
}

extension StringExtensions on String {
  bool containsIgnoreCase(String secondString) =>
      toLowerCase().contains(secondString.toLowerCase());

  //bool isNotBlank() => this != null && this.isNotEmpty;
}
