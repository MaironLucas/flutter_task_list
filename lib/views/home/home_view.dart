import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/data_observables.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/action_handler.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/home/home_bloc.dart';
import 'package:flutter_task_list/views/home/home_model.dart';
import 'package:flutter_task_list/views/settings/settings_page.dart';
import 'package:flutter_task_list/views/task/list/task_list_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.bloc, super.key});

  final HomeBloc bloc;

  static Widget create() => ProxyProvider3<TaskRepository, UserRepository,
          TaskListUpdateSinkWrapper, HomeBloc>(
        update: (
          _,
          taskRepository,
          userRepository,
          taskListUpdateSinkWrapper,
          __,
        ) =>
            HomeBloc(
          taskRepository: taskRepository,
          userRepository: userRepository,
          taskListUpdateSink: taskListUpdateSinkWrapper.value,
        ),
        child: Consumer<HomeBloc>(
          builder: (_, bloc, __) => HomePage(
            bloc: bloc,
          ),
        ),
        dispose: (_, bloc) => bloc.dispose(),
      );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController pc;
  List<String> title = ['Tasks', 'Profile & Preferences'];

  Map<int, GlobalKey> navigatorKeys = {
    0: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: _selectedIndex);
  }

  void setCurrentPage(page) {
    setState(() {
      _selectedIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ActionHandler<HomeAction>(
        actionStream: widget.bloc.onHomeAction,
        onReceived: (action) {
          if (action is SuccessOnCreateTask) {
            Navigator.of(context).pop();
            displaySnackBar(context, 'Task successfully created!');
            _selectedIndex = 0;
          } else if (action is FailOnCreateTask) {
            displaySnackBar(context, 'Failed to create Task!');
          }
        },
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pc,
              onPageChanged: setCurrentPage,
              children: [
                TaskListPage.create(navigatorKeys[0]!),
                SettingsPage.create(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Colors.indigoAccent,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outlined),
                    activeIcon: Icon(Icons.person),
                    label: ''),
              ],
              currentIndex: _selectedIndex,
              onTap: (page) {
                pc.animateToPage(page,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease);
              },
              // onTap: (value) => setCurrentPage(value)),
            ),
          ),
        ));
  }
}
