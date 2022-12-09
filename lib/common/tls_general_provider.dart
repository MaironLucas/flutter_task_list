import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/cache/data_source/character_cds.dart';
import 'package:flutter_task_list/data/cache/data_source/user_preference_cds.dart';
import 'package:flutter_task_list/data/data_observables.dart';
import 'package:flutter_task_list/data/login_state_handler.dart';
import 'package:flutter_task_list/data/remote/data_source/character_rds.dart';
import 'package:flutter_task_list/data/remote/data_source/step_rds.dart';
import 'package:flutter_task_list/data/remote/data_source/task_rds.dart';
import 'package:flutter_task_list/data/remote/data_source/user_rds.dart';
import 'package:flutter_task_list/data/repository/character_repository.dart';
import 'package:flutter_task_list/data/repository/step_repository.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_preference_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';

class TslGeneralProvider extends StatefulWidget {
  const TslGeneralProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  State<TslGeneralProvider> createState() => _TslGeneralProviderState();
}

class _TslGeneralProviderState extends State<TslGeneralProvider> {
  final _taskListSubject = PublishSubject<void>();

  @override
  void dispose() {
    _taskListSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ...buildDataObservables(),
          ...changeNotifiersProviders(),
          ...firebaseProviders(),
          ...rdsProviders(),
          ...cdsProvider(),
          ...repositoryProviders(),
        ],
        child: widget.child,
      );

  List<SingleChildWidget> buildDataObservables() => [
        Provider<TaskListUpdateStreamWrapper>(
          create: (_) => TaskListUpdateStreamWrapper(_taskListSubject.stream),
        ),
        Provider<TaskListUpdateSinkWrapper>(
          create: (_) => TaskListUpdateSinkWrapper(_taskListSubject.sink),
        )
      ];

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
        ProxyProvider<DatabaseReference, StepRds>(
          update: (_, database, __) => StepRds(database: database),
        ),
        Provider<CharacterRDS>(
          create: (_) => CharacterRDS(),
        ),
      ];

  List<SingleChildWidget> cdsProvider() => [
        Provider<UserPreferenceCDS>(
          create: (_) => UserPreferenceCDS(),
        ),
        Provider<CharacterCDS>(
          create: (_) => CharacterCDS(),
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
        ProxyProvider<StepRds, StepRepository>(
          update: (_, stepRds, __) => StepRepository(stepRds: stepRds),
        ),
        ProxyProvider<UserPreferenceCDS, UserPreferenceRepository>(
          update: (_, userPreferenceCDS, __) =>
              UserPreferenceRepository(userPreferenceCDS: userPreferenceCDS),
        ),
        ProxyProvider2<CharacterCDS, CharacterRDS, CharacterRepository>(
          update: (_, characterCDS, characterRDS, __) => CharacterRepository(
            characterRDS: characterRDS,
            characterCDS: characterCDS,
          ),
        ),
      ];

  List<SingleChildWidget> changeNotifiersProviders() => [
        ChangeNotifierProvider<LoginStateHandler>(
          create: (_) => LoginStateHandler(),
        ),
      ];
}
