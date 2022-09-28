import 'package:flutter/material.dart';
import 'package:projeto_mobile/widgets/login_widget.dart';
import 'package:projeto_mobile/widgets/register_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Icon(
                Icons.wb_sunny,
                color: Color.fromRGBO(49, 45, 84, 1),
              ),
            ],
          ),
        ),
        body: login
            ? LoginWidget(changeScreen: changeScreen)
            : RegisterWidget(changeScreen: changeScreen));
  }
}
