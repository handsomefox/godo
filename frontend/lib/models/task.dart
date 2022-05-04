import 'dart:convert';

import 'package:intl/intl.dart';

class Task {
  String? id;
  final String name;
  final String desc;
  final List<String> subtasks;
  final DateTime? due;
  bool completed;

  Task({
    this.id,
    required this.name,
    required this.desc,
    required this.subtasks,
    required this.due,
    this.completed = false,
  });

  factory Task.fromJson(Map<String, dynamic> body) {
    return Task(
        id: body['id'],
        name: body['name'],
        desc: body['desc'],
        subtasks: ['subtasks'],
        due: DateTime.parse(body['due']));
  }

  void toggleCompleted() {
    completed = !completed;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};

    if (name.isNotEmpty) {
      map['name'] = name;
    }

    if (desc.isNotEmpty) {
      map['desc'] = desc;
    }

    if (subtasks.isNotEmpty) {
      map['subtasks'] = jsonEncode(subtasks);
    }

    if (due != null) {
      var formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      map['due'] = formatter.format(due as DateTime);
    }

    return map;
  }
}
