import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/auth/auth_view.dart';
import 'package:flutter_task_list/views/settings/settings_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_list/config.dart';

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
    List<String> orderByList = ["Ascending", "Descending"];
    List<String> fontSizeList = ["Small", "Medium", "Large"];
    // return Material(
    //   child: TextButton(
    //     onPressed: () {
    //       FirebaseAuth.instance.signOut();
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const AuthPage(),
    //         ),
    //       );
    //     },
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: const [
    //         Text('Wanna leave?'),
    //         Text(
    //           'LOG OUT',
    //           style: TextStyle(
    //             color: Colors.red,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.import_export,
                        color: Colors.indigoAccent,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Order By",
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 120,
                    child: DropdownButton<String>(
                      value: currentTheme.getOrderBy(),
                      icon: const Material(),
                      elevation: 16,
                      style: Theme.of(context).textTheme.labelSmall,
                      underline: Container(
                        height: 1,
                        color: Colors.indigoAccent,
                      ),
                      onChanged: (String? value) {
                        currentTheme.switchOrderBy(value);
                      },
                      items: orderByList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.font_download,
                        color: Colors.indigoAccent,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Font Size",
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 120,
                    child: DropdownButton<String>(
                      value: currentTheme.getFontSize(),
                      icon: const Material(),
                      elevation: 16,
                      style: Theme.of(context).textTheme.labelSmall,
                      underline: Container(
                        height: 1,
                        color: Colors.indigoAccent,
                      ),
                      onChanged: (String? value) {
                        currentTheme.switchFontSize(value);
                      },
                      items: fontSizeList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              height: 40,
              thickness: 0.5,
              indent: 10,
              endIndent: 10,
              color: Colors.grey,
            ),
            SizedBox(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.badge,
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Nome",
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("Tiago Comeron de Sousa"),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.alternate_email,
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Email",
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("tiago@email.com"),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.key_off,
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Password",
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("*******************"),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                height: 40,
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
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
