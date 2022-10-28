import 'package:flutter/material.dart';
import 'package:flutter_task_list/config.dart';
import 'package:flutter_task_list/views/create/create_page.dart';
import 'package:flutter_task_list/views/list/lists_page.dart';
import 'package:flutter_task_list/views/settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<String> title = ['Tasks', 'Create', 'Settings'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = (index != 1) ? index : _selectedIndex;
    });

    if (index == 1) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return const CreatePage();
          });
    }
  }

  List<String> tarefas = [
    "Tarefa 1",
    "Tarefa 2",
    "Tarefa 3",
    "Tarefa 4",
    "Tarefa 5",
    "Tarefa 6",
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              ListsPage.create(tarefas),
              const Material(),
              SettingsPage.create(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.indigoAccent,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: ''),
            BottomNavigationBarItem(
              icon: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.indigoAccent, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(14),
                  child: const Icon(
                    Icons.add,
                    color: Color.fromRGBO(217, 217, 217, 1),
                  ),
                ),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: ''),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
