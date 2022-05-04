import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 6),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        print("Clicked back button. We should save the task");
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Icon(Icons.arrow_back_sharp),
                      ),
                    ),
                    Expanded(
                        child: TextField(
                      onSubmitted: (value) {},
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.taskHint,
                        border: InputBorder.none,
                      ),
                    )),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter description for the task",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      )),
                ),
              ),
              Todo(done: false, text: "text"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.createNewTask,
        onPressed: () {},
        child: const Icon(Icons.delete),
      ),
    );
  }
}

class Todo extends StatefulWidget {
  const Todo({Key? key, required this.text, required this.done})
      : super(key: key);
  final String text;
  final bool done;

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(children: [
        Container(
          width: 20.0,
          height: 20.0,
          margin: const EdgeInsets.only(
            right: 16.0,
          ),
          color: Theme.of(context).colorScheme.secondary,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: widget.done
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank),
        ),
        Text(
          widget.text.isEmpty ? "" : widget.text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        )
      ]),
    );
  }
}
