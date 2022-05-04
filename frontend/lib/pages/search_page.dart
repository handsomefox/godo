// Search Page
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/models/task_model.dart';
import 'package:frontend/providers/task_provider.dart';
import 'package:frontend/widgets/task_card_list_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  TaskCardListWidget searchList = const TaskCardListWidget(tasks: []);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        width: double.infinity,
        height: 32,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: TextField(
            onChanged: (String value) {
              UnmodifiableListView<Task> filtered =
                  Provider.of<TasksProvider>(context, listen: false)
                      .filtered(context, value);
              setState(() {
                searchList = TaskCardListWidget(tasks: filtered);
              });
            },
            controller: _searchController,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  iconSize: 16,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                hintText: AppLocalizations.of(context)!.search,
                border: InputBorder.none),
          ),
        ),
      )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              searchList,
            ],
          ),
        ),
      ),
    );
  }
}
