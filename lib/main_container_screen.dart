import 'package:flutter/material.dart';
import 'package:flutter_task_list/common/tls_general_provider.dart';
import 'package:flutter_task_list/data/dummy_state_handler.dart';
import 'package:flutter_task_list/views/auth/auth_view.dart';
import 'package:flutter_task_list/views/home/home_view.dart';
import 'package:provider/provider.dart';

class MainContainerScreen extends StatelessWidget {
  const MainContainerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TslGeneralProvider(
        child: Consumer<DummyStateHandler>(
          builder: (context, dummyState, _) =>
              dummyState.isLoggedIn ? const HomePage() : const AuthPage(),
        ),
      );
}
