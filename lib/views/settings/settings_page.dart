import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/auth/auth_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  //static Widget create() => ProxyProvider()

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
