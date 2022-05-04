// Search Page
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/providers/task_model.dart';
import 'package:frontend/widgets/task_list.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  var list = const TaskList(
    tasks: [],
  );
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
            onChanged: (value) {
              var filtered = Provider.of<TaskModel>(context, listen: false)
                  .getFilteredTasks(context, value);
              setState(() {
                list = TaskList(tasks: filtered);
              });
            },
            controller: searchController,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  iconSize: 16,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
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
              list,
            ],
          ),
        ),
      ),
    );
  }
}
