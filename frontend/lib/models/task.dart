class Task {
  final String name;
  final String desc;
  final List<String> subtasks;
  final DateTime due;
  bool completed;

  Task({
    required this.name,
    required this.desc,
    required this.subtasks,
    required this.due,
    this.completed = false,
  });

  void toggleCompleted() {
    completed = !completed;
  }
}
