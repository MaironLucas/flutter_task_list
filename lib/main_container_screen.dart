import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/login_state_handler.dart';
import 'package:flutter_task_list/views/auth/auth_view.dart';
import 'package:flutter_task_list/views/home/home_view.dart';
import 'package:provider/provider.dart';

class MainContainerScreen extends StatelessWidget {
  const MainContainerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<LoginStateHandler>(
        builder: (context, dummyState, _) =>
            dummyState.loggedIn ? const HomePage() : const AuthPage(),
      );
}
