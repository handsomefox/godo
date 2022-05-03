import 'package:flutter/material.dart';
import 'widgets/mainwidget.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MainWidget();
  }
}

void main() {
  runApp(const TodoApp());
}
