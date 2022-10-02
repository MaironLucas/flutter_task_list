import 'package:flutter/material.dart';
import 'package:flutter_task_list/config.dart';
import 'package:flutter_task_list/views/auth/sign_in/sign_in_widget.dart';
import 'package:flutter_task_list/views/auth/sign_up/sign_up_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool login = true;

  changeScreen(bool state) {
    setState(() {
      login = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ? SignInWidget(changeScreen: changeScreen)
              : SignUpWidget(changeScreen: changeScreen),
        ));
  }
}
