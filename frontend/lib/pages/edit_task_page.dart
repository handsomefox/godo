import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/task_model.dart';
import 'package:frontend/providers/task_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/name_input_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage(
      {Key? key, required this.task, required this.isNew, required this.user})
      : super(key: key);
  final User? user;
  final Task task;
  final bool isNew;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final DateFormat _dateTimeFormatter = DateFormat();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  DateTime? _inputDateTime;
  late Task _stateTask;
  late List<Subtask> _subtasks;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _descController = TextEditingController(text: widget.task.desc);
    if (widget.task.due != null) {
      _inputDateTime = widget.task.due;
    }
    _stateTask = widget.task;
    _subtasks = widget.task.subtasks.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 6,
              ),
              child: Row(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        if (_nameController.text.isEmpty) {
                          // Task should always have a name unless it is a new task
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.taskHint)));
                          if (widget.isNew) {
                            Navigator.pop(context);
                            // go back
                          }
                          // Dont do anything
                          return;
                        }

                        // Dont do anything if data didn't change
                        if (_nameController.text == widget.task.name &&
                            _descController.text == widget.task.desc &&
                            _inputDateTime == widget.task.due &&
                            _stateTask.subtasks == widget.task.subtasks &&
                            listEquals(_subtasks, widget.task.subtasks)) {
                          Navigator.pop(context);
                          return;
                        }

                        // Validate name
                        if (!_nameController.text.isValidName()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.invalidName)));
                          return;
                        }

                        // Get the data
                        _stateTask.name = _nameController.text;
                        _stateTask.desc = _descController.text;
                        _stateTask.due = _inputDateTime;
                        _stateTask.subtasks = _subtasks;

                        // onAdd logic
                        if (widget.isNew) {
                          // Add a new task
                          Provider.of<TasksProvider>(context, listen: false)
                              .add(_stateTask, widget.user);
                        } else {
                          // Update an existing task
                          Provider.of<TasksProvider>(context, listen: false)
                              .update(_stateTask, widget.user);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text(AppLocalizations.of(context)!.dbHint)));

                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(
                          24,
                        ),
                        child: Icon(
                          Icons.arrow_back_sharp,
                        ),
                      )),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.taskHint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _descController,
                maxLines: 4,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: getCardColor(context),
                  hintText: AppLocalizations.of(context)!.descriptionHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: Text(
                  _inputDateTime == null
                      ? ''
                      : AppLocalizations.of(context)!.selectedTIme +
                          _dateTimeFormatter.format(_inputDateTime as DateTime),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: SubtaskWidget(
                      isInputWidget: false,
                      subtask: _subtasks[index],
                      onChange: (Subtask modifiedSutask, String value) {
                        setState(() {
                          if (value.isEmpty) {
                            _subtasks.remove(modifiedSutask);
                          }

                          if (_subtasks.contains(modifiedSutask)) {
                            var index = _subtasks.indexOf(modifiedSutask);
                            _subtasks[index] = modifiedSutask;
                            _subtasks[index].name = value;
                          }
                        });
                      },
                    ),
                  );
                },
                itemCount: _subtasks.length,
                shrinkWrap: false,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 4)),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: SubtaskWidget(
                isInputWidget: true,
                subtask: Subtask.empty,
                onChange: (Subtask modifiedSubtask, String value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      modifiedSubtask.name = value;
                      _subtasks.add(modifiedSubtask);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            tooltip: AppLocalizations.of(context)!.selectDateTooltip,
            onPressed: () async {
              DateTime? selected = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 365 * 8),
                  ));

              if (selected != null) {
                setState(() {
                  _inputDateTime = selected;
                });
              }
            },
            heroTag: null,
            child: const Icon(
              Icons.date_range,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            tooltip: AppLocalizations.of(context)!.createNewTask,
            onPressed: () {
              if (!widget.isNew) {
                Provider.of<TasksProvider>(context, listen: false)
                    .remove(widget.task);
              }

              Navigator.of(context).pop();
            },
            heroTag: null,
            child: const Icon(
              Icons.delete,
            ),
          ),
          const SizedBox(
            height: 64,
          ),
        ],
      ),
    );
  }
}

class SubtaskWidget extends StatefulWidget {
  const SubtaskWidget(
      {Key? key,
      required this.subtask,
      required this.isInputWidget,
      required this.onChange})
      : super(key: key);

  final void Function(Subtask, String) onChange;
  final Subtask subtask;

  final bool isInputWidget;

  @override
  State<SubtaskWidget> createState() => _SubtaskWidgetState();
}

class _SubtaskWidgetState extends State<SubtaskWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.subtask.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(children: <Widget>[
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(right: 16),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (!widget.isInputWidget) {
                  widget.subtask.completed = !widget.subtask.completed;
                }
              });
            },
            child: widget.subtask.completed
                ? Icon(
                    Icons.check_box_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : Icon(
                    Icons.check_box_outline_blank,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
          ),
        ),
        Expanded(
          child: TextField(
            onSubmitted: (String value) {
              widget.onChange(widget.subtask, value);
              if (widget.isInputWidget) {
                _textController.clear();
              }
            },
            controller: _textController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.todoHint,
              border: InputBorder.none,
            ),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}

Color getCardColor(BuildContext context) {
  switch (Theme.of(context).brightness) {
    case Brightness.dark:
      return Colors.grey.shade900;
    case Brightness.light:
      return Colors.white;
  }
}
