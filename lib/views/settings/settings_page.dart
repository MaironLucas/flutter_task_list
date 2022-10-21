import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/auth/auth_view.dart';
import 'package:flutter_task_list/views/settings/settings_bloc.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.bloc,
  });

  final SettingsBloc bloc;

  static Widget create() => ProxyProvider<UserRepository, SettingsBloc>(
        update: (_, userRepository, __) => SettingsBloc(
          userRepository: userRepository,
        ),
        child: Consumer<SettingsBloc>(
          builder: (_, bloc, __) => SettingsPage(
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthPage(),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Wanna leave?'),
            Text(
              'LOG OUT',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
