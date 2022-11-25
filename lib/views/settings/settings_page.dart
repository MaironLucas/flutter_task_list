import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/repository/user_preference_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/auth/auth_view.dart';
import 'package:flutter_task_list/views/common/async_snapshot_response_view.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/settings/modal/edit_user_modal.dart';
import 'package:flutter_task_list/views/settings/settings_bloc.dart';
import 'package:flutter_task_list/views/settings/settings_models.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_list/config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.bloc,
  });

  final SettingsBloc bloc;

  static Widget create() =>
      ProxyProvider2<UserRepository, UserPreferenceRepository, SettingsBloc>(
        update: (_, userRepository, userPreferenceRepository, __) =>
            SettingsBloc(
          userRepository: userRepository,
          userPreferenceRepository: userPreferenceRepository,
        ),
        child: Consumer<SettingsBloc>(
          builder: (_, bloc, __) => SettingsPage(
            bloc: bloc,
          ),
        ),
      );

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsBloc get bloc => widget.bloc;
  void _onFabPress(name) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: EditUserModal.create(name),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> orderByList = ["Ascending", "Descending"];
    List<String> themeList = ["Dark", "Light"];

    return StreamBuilder(
      stream: bloc.onNewState,
      builder: (_, snapshot) =>
          AsyncSnapshotResponseView<Loading, Error, Success>(
        snapshot: snapshot,
        successWidgetBuilder: (_, success) {
          final user = success.user;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Preferences & Profile",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.indigoAccent,
                onPressed: () => _onFabPress(user.name),
                child: const Icon(
                  Icons.edit,
                  color: Color.fromRGBO(217, 217, 217, 1),
                )),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Icon(
                                    Icons.import_export,
                                    color: Colors.indigoAccent,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Order By",
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 120,
                                child: DropdownButton<String>(
                                  value: success.orderBy,
                                  icon: const Material(),
                                  elevation: 16,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  underline: Container(
                                    height: 1,
                                    color: Colors.indigoAccent,
                                  ),
                                  onChanged: (String? value) {
                                    bloc.onOrderByChanged.add(
                                      value ?? 'Descending',
                                    );
                                  },
                                  items: orderByList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                          width: 130,
                        ),
                        SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Icon(
                                    Icons.wb_sunny,
                                    color: Colors.indigoAccent,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Theme",
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 120,
                                child: DropdownButton<String>(
                                  value: currentTheme.getTheme(),
                                  icon: const Material(),
                                  elevation: 16,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  underline: Container(
                                    height: 1,
                                    color: Colors.indigoAccent,
                                  ),
                                  onChanged: (String? value) {
                                    currentTheme.switchTheme(value);
                                  },
                                  items: themeList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                      ],
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
                            children: const [
                              Icon(
                                Icons.badge,
                                color: Color.fromRGBO(217, 217, 217, 1),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Nome",
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(user.name),
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
                            children: const [
                              Icon(
                                Icons.alternate_email,
                                color: Color.fromRGBO(217, 217, 217, 1),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Email",
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(user.email),
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
                            children: const [
                              Icon(
                                Icons.key_off,
                                color: Color.fromRGBO(217, 217, 217, 1),
                              ),
                              Padding(
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
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
