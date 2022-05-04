import 'dart:convert';

import 'package:intl/intl.dart';

class Subtask {
  Subtask({required this.name, required this.completed});
  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
        name: json['name'] as String, completed: json['completed'] as bool);
  }
  String name;
  bool completed;

  static Subtask get empty => Subtask(name: '', completed: false);

  void toggle() {
    completed = !completed;
  }
}

class Task {
  Task({
    this.id,
    required this.name,
    required this.desc,
    required this.subtasks,
    required this.due,
    this.completed = false,
  });

  factory Task.fromJson(Map<String, dynamic> body) {
    List<Subtask> subs = [];
    if (body['subtasks'] != null) {
      List<dynamic> items = body['subtasks'] as List<dynamic>;
      for (var item in items) {
        Subtask subtask = Subtask.fromJson(item as Map<String, dynamic>);
        subs.add(subtask);
      }
    }

    DateTime? time;
    if (body['due'] != null) {
      time = DateTime.parse(body['due'] as String);
    }

    return Task(
      id: body['id'] as String,
      name: body['name'] as String,
      desc: body['desc'] as String,
      subtasks: subs,
      due: time,
    );
  }

  String? id;
  final String name;
  final String desc;
  final List<Subtask> subtasks;
  final DateTime? due;
  bool completed;

  static Task get empty => Task(name: '', desc: '', subtasks: [], due: null);

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
      DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      map['due'] = formatter.format(due as DateTime);
    }

    return map;
  }
}
