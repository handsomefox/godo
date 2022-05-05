import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/models/task_model.dart';
import 'package:frontend/pages/register_page.dart';
import 'package:frontend/pages/search_page.dart';
import 'package:frontend/pages/edit_task_page.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/widgets/app_widget.dart';
import 'package:frontend/widgets/user_data_widget.dart';
import 'package:frontend/providers/task_provider.dart';
import 'package:frontend/widgets/task_card_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);
  final User? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

enum VerticalMenuOptions {
  signIn,
  signOut,
  signUp,
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                tooltip: AppLocalizations.of(context)!.search,
                icon: const Icon(
                  Icons.search,
                  size: 26.0,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => SearchPage(
                            user: widget.user,
                          )),
                ),
              ),
              PopupMenuButton(
                color: Theme.of(context).colorScheme.background,
                tooltip: AppLocalizations.of(context)!.menu,
                onSelected: handleOnSelectedVerticalMenu,
                icon: const Icon(Icons.more_vert),
                itemBuilder: popupMenuBuilder,
              ),
            ],
            title: Row(
              children: [
                const Icon(
                  Icons.logo_dev_sharp,
                ),
                const Padding(
                  padding: EdgeInsets.all(4),
                ),
                Text(
                  AppLocalizations.of(context)!.appName,
                ),
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
                      userIcon: Icons.person,
                    ),
                    margin: const EdgeInsets.only(
                      top: 24,
                      bottom: 20.0,
                    ),
                  ),
                  Consumer<TasksProvider>(
                    builder: (BuildContext context, TasksProvider value,
                            Widget? child) =>
                        TaskCardListWidget(
                      tasks: value.tasks(context),
                      user: widget.user,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: AppLocalizations.of(context)!.createNewTask,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EditTaskPage(
                  isNew: true,
                  task: Task.empty,
                  user: widget.user,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.add,
          ),
        ));
  }

  List<PopupMenuEntry<VerticalMenuOptions>> popupMenuBuilder(
      BuildContext context) {
    List<PopupMenuItem<VerticalMenuOptions>> list = [];

    list.add(PopupMenuItem<VerticalMenuOptions>(
      textStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      value: widget.user == null
          ? VerticalMenuOptions.signIn
          : VerticalMenuOptions.signOut,
      child: Text(widget.user == null
          ? AppLocalizations.of(context)!.logInText
          : AppLocalizations.of(context)!.logOutText),
    ));
    if (widget.user == null) {
      list.add(PopupMenuItem<VerticalMenuOptions>(
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        value: VerticalMenuOptions.signUp,
        child: Text(AppLocalizations.of(context)!.registerText),
      ));
    }
    return list;
  }

  void handleOnSelectedVerticalMenu(VerticalMenuOptions value) {
    switch (value) {
      case VerticalMenuOptions.signIn:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const LoginPage()));
        break;
      case VerticalMenuOptions.signUp:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const RegisterPage()));
        break;
      case VerticalMenuOptions.signOut:
        StorageService.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const AppWidget(user: null),
              maintainState: false),
          (Route route) => false,
        );

        break;
    }
  }

  List<PopupMenuItem<VerticalMenuOptions>> buildVerticalMenu(
      BuildContext context) {
    List<PopupMenuItem<VerticalMenuOptions>> list = [];

    list.add(PopupMenuItem<VerticalMenuOptions>(
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      value: widget.user == null
          ? VerticalMenuOptions.signIn
          : VerticalMenuOptions.signOut,
      child: Text(widget.user == null
          ? AppLocalizations.of(context)!.logInText
          : AppLocalizations.of(context)!.logOutText),
    ));

    if (widget.user == null) {
      list.add(PopupMenuItem<VerticalMenuOptions>(
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        value: VerticalMenuOptions.signUp,
        child: Text(AppLocalizations.of(context)!.registerText),
      ));
    }

    return list;
  }
}
