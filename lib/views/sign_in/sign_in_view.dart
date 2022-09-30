import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/register/register_widget.dart';
import 'package:flutter_task_list/views/sign_in/sign_in_widget.dart';

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(
                Icons.wb_sunny,
                color: Color.fromRGBO(49, 45, 84, 1),
              ),
            ],
          ),
        ),
        body: login
            ? SignInWidget(changeScreen: changeScreen)
            : RegisterWidget(changeScreen: changeScreen));
  }
}
