import 'package:flutter/material.dart';
import 'package:frontend/auth.dart';
import 'package:frontend/pages/add.dart';
import 'package:frontend/pages/register.dart';
import 'package:frontend/pages/search.dart';
import 'package:frontend/storage.dart';
import 'package:frontend/widgets/mainwidget.dart';
import 'package:frontend/widgets/user.dart';
import 'package:frontend/providers/task_model.dart';
import 'package:frontend/widgets/task_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);
  final User? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

enum PopupValues {
  settings,
  signin,
  signout,
  signup,
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: buildAppBarActions,
            title: Row(
              children: [
                const Icon(Icons.logo_dev_sharp),
                const Padding(padding: EdgeInsets.all(4)),
                Text(AppLocalizations.of(context)!.appName),
              ],
            )),
        body: SizedBox(
          width: double.infinity,
          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: UserDataWidget(
                        name: widget.user == null
                            ? AppLocalizations.of(context)!.defaulUsername
                            : widget.user!.name,
                        userIcon: Icons.person),
                    margin: const EdgeInsets.only(top: 24, bottom: 20.0),
                  ),
                  Consumer<TaskModel>(
                      builder: (context, value, child) =>
                          TaskList(tasks: value.getTasks(context))),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: AppLocalizations.of(context)!.createNewTask,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AddTaskScreen(user: widget.user)));
          },
          child: const Icon(Icons.add),
        ));
  }

  List<Widget> get buildAppBarActions {
    return <Widget>[
      IconButton(
        tooltip: AppLocalizations.of(context)!.search,
        icon: const Icon(
          Icons.search,
          size: 26.0,
        ),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SearchPage())),
      ),
      PopupMenuButton(
          color: Theme.of(context).colorScheme.background,
          tooltip: AppLocalizations.of(context)!.menu,
          onSelected: onSelectedVerticalMenu,
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) {
            return buildVerticalMenu(context);
          }),
    ];
  }

  void onSelectedVerticalMenu(value) {
    switch (value) {
      case PopupValues.signin:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const LoginPage()));
        break;
      case PopupValues.signup:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const RegisterPage()));
        break;
      case PopupValues.signout:
        MyStorage.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const MainWidget(), maintainState: false),
          (route) => false,
        );

        break;
    }
  }

  List<PopupMenuItem<PopupValues>> buildVerticalMenu(BuildContext context) {
    var list = List<PopupMenuItem<PopupValues>>.empty(growable: true);

    list.add((PopupMenuItem<PopupValues>(
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      value: widget.user == null ? PopupValues.signin : PopupValues.signout,
      child: Text(widget.user == null
          ? AppLocalizations.of(context)!.logInText
          : AppLocalizations.of(context)!.logOutText),
    )));

    if (widget.user == null) {
      list.add(PopupMenuItem<PopupValues>(
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        value: PopupValues.signup,
        child: Text(AppLocalizations.of(context)!.registerText),
      ));
    }

    return list;
  }
}
