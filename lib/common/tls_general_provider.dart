import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/login_state_handler.dart';
import 'package:flutter_task_list/data/remote/data_source/task_rds.dart';
import 'package:flutter_task_list/data/remote/data_source/user_rds.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class TslGeneralProvider extends StatelessWidget {
  const TslGeneralProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ...changeNotifiersProviders(),
          ...firebaseProviders(),
          ...rdsProviders(),
          ...repositoryProviders(),
        ],
        child: child,
      );

  List<SingleChildWidget> firebaseProviders() => [
        Provider<DatabaseReference>(
          create: (_) => FirebaseDatabase.instance.ref(),
        ),
        Provider<FirebaseAuth>(
          create: (_) => FirebaseAuth.instance,
        ),
      ];

  List<SingleChildWidget> rdsProviders() => [
        ProxyProvider<FirebaseAuth, UserRds>(
          update: (_, firebaseAuth, __) => UserRds(
            firebaseAuth: firebaseAuth,
          ),
        ),
        ProxyProvider<DatabaseReference, TaskRds>(
          update: (_, database, __) => TaskRds(
            database: database,
          ),
        ),
      ];

  List<SingleChildWidget> repositoryProviders() => [
        ProxyProvider<UserRds, UserRepository>(
          update: (_, userRds, __) => UserRepository(
            userRds: userRds,
          ),
        ),
        ProxyProvider<TaskRds, TaskRepository>(
          update: (_, taskRds, __) => TaskRepository(
            taskRds: taskRds,
          ),
        ),
      ];

  List<SingleChildWidget> changeNotifiersProviders() => [
        ChangeNotifierProvider<LoginStateHandler>(
          create: (_) => LoginStateHandler(),
        ),
      ];
}
