import 'package:flutter/material.dart';
import 'package:flutter_task_list/config.dart';
import 'package:flutter_task_list/views/auth/sign_in/sign_in_widget.dart';
import 'package:flutter_task_list/views/auth/sign_up/sign_up_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late PageController pc;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: _selectedIndex);
  }

  void changeScreen(page) {
    setState(() {
      _selectedIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          SignInWidget.create(changeScreen),
          SignUpWidget.create(changeScreen),
        ],
      ),
      // child: PageView(
      //   physics: const NeverScrollableScrollPhysics(),
      //   controller: pc,
      //   children: [
      //     SignInWidget.create(changeScreen),
      //     SignUpWidget.create(changeScreen),
      //   ],
      // ),
    );
  }
}
