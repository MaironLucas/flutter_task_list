import 'package:flutter/material.dart';
import 'package:flutter_task_list/config.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/action_handler.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/home/home_bloc.dart';
import 'package:flutter_task_list/views/home/home_model.dart';
import 'package:flutter_task_list/views/home/modal/create_task_modal.dart';
import 'package:flutter_task_list/views/settings/settings_page.dart';
import 'package:flutter_task_list/views/task/list/task_list_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.bloc, super.key});

  final HomeBloc bloc;

  static Widget create() =>
      ProxyProvider2<TaskRepository, UserRepository, HomeBloc>(
        update: (
          _,
          taskRepository,
          userRepository,
          __,
        ) =>
            HomeBloc(
          taskRepository: taskRepository,
          userRepository: userRepository,
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              title[_selectedIndex],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            actions: [
              IconButton(
                onPressed: () => currentTheme.switchTheme(),
                icon: const Icon(
                  Icons.wb_sunny,
                  color: Color.fromRGBO(217, 217, 217, 1),
                ),
              )
            ],
          ),
          body: Center(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pc,
              onPageChanged: setCurrentPage,
              children: [
                TaskListPage.create(),
                SettingsPage.create(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return CreateTaskModal(
                      onCreateTaskTap: (TaskInput input) {
                        return widget.bloc.onCreateTaskTap.add(input);
                      },
                    );
                  });
            },
            backgroundColor: Colors.indigoAccent,
            child: const Icon(
              Icons.add,
              color: Color.fromRGBO(217, 217, 217, 1),
            ),
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
            // onTap: _onItemTapped,
            onTap: (page) => pc.animateToPage(page,
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease),
          ),
        ),
      ),
    );
  }
}
