import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/providers/task_model.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void onAdd() {
    final String textVal = taskTitleController.text;
    final String descVal = taskDescriptionController.text;
    if (textVal.isNotEmpty) {
      final Task task = Task(
        name: textVal,
        desc: descVal,
        due: selectedDate,
        subtasks: [],
      );
      Provider.of<TaskModel>(context, listen: false).add(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(
                    top: 50,
                  ),
                ),
                TextField(
                  cursorColor: Theme.of(context).colorScheme.onBackground,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                    label: const Text("Name"),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  controller: taskTitleController,
                ),
                const Padding(padding: EdgeInsets.only(bottom: 8)),
                TextField(
                  cursorColor: Theme.of(context).colorScheme.onBackground,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                    label: const Text("Description"),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  controller: taskDescriptionController,
                ),
                const Padding(padding: EdgeInsets.only(bottom: 8)),
                TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(12, 24, 0, 24)),
                  ),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(), onConfirm: (date) {
                      selectedDate = date;
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    "Select date",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                ElevatedButton(
                    onPressed: onAdd,
                    child: Text(AppLocalizations.of(context)!.add))
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }
}
