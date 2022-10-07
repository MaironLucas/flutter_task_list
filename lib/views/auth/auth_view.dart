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
  bool login = true;

  changeScreen(bool state) {
    setState(() {
      login = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => currentTheme.switchTheme(),
                icon: const Icon(
                  Icons.wb_sunny,
                  color: Color.fromRGBO(217, 217, 217, 1),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: login
              ? SignInWidget.create(changeScreen)
              : SignUpWidget.create(changeScreen),
        ),
      ),
    );
  }
}
