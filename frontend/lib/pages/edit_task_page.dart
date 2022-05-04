import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/models/task_model.dart';
import 'package:intl/intl.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({Key? key, required this.task}) : super(key: key);
  final Task task;
  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final DateFormat _dateTimeFormatter = DateFormat();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  DateTime? _inputDateTime;
  late Task _stateTask;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _descController = TextEditingController(text: widget.task.desc);
    if (widget.task.due != null) {
      _inputDateTime = widget.task.due;
    }
    _stateTask = widget.task;
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
                        // Here's where we call all our onAdd logic
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
                      onSubmitted: (String value) {},
                      style: TextStyle(
                        fontSize: 26,
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
                height: 64,
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
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                    child: Expanded(
                      child: SubtaskWidget(
                        subtask: _stateTask.subtasks[index],
                        task: _stateTask,
                        onChange: (Task modifiedTask) {
                          setState(() {
                            _stateTask = modifiedTask;
                          });
                        },
                      ),
                    ),
                  );
                },
                itemCount: _stateTask.subtasks.length,
                shrinkWrap: false,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 4)),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Expanded(
                child: SubtaskWidget(
                  task: _stateTask,
                  subtask: Subtask.empty,
                  onChange: (Task task) {
                    setState(() {
                      _stateTask = task;
                    });
                  },
                ),
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
            height: 10,
          ),
          FloatingActionButton(
            tooltip: AppLocalizations.of(context)!.createNewTask,
            onPressed: () {},
            heroTag: null,
            child: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
    );
  }
}

class SubtaskWidget extends StatefulWidget {
  const SubtaskWidget(
      {Key? key,
      required this.task,
      required this.subtask,
      required this.onChange})
      : super(key: key);

  final void Function(Task) onChange;
  final Task task;
  final Subtask subtask;
  // where we add the data later
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: getCardColor(context),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(children: <Widget>[
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 16),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.task.completed = !widget.task.completed;
              });
            },
            child: widget.task.completed
                ? Icon(
                    Icons.check_box,
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
              if (value.isEmpty) {
                if (widget.task.subtasks.contains(widget.subtask)) {
                  widget.task.subtasks.remove(widget.subtask);
                }
                widget.onChange(widget.task);
                return;
              }

              if (widget.task.subtasks.contains(widget.subtask)) {
                int index = widget.task.subtasks.indexOf(widget.subtask);
                widget.subtask.name = value;
                widget.task.subtasks[index] = widget.subtask;
                widget.onChange(widget.task);
                return;
              }

              widget.subtask.name = value;
              widget.task.subtasks.add(widget.subtask);
              widget.onChange(widget.task);
            },
            controller: _textController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.todoHint,
              border: InputBorder.none,
            ),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 16,
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
