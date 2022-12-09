import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/settings/settings_page.dart';
import 'package:flutter_task_list/views/task/list/task_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Widget create() => const HomePage();

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
    return WillPopScope(
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
          selectedItemColor: Colors.blue,
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
    );
  }
}
