import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/dummy_state_handler.dart';
import 'package:flutter_task_list/data/remote/data_source/user_rds.dart';
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
          ...rdsProviders(),
          ...repositoryProviders(),
        ],
        child: child,
      );

  List<SingleChildWidget> rdsProviders() => [
        ProxyProvider<DummyStateHandler, UserRds>(
          update: (_, dummyStateHandler, userRds) => UserRds(
            dummyStateHandler: dummyStateHandler,
          ),
        ),
      ];

  List<SingleChildWidget> repositoryProviders() => [
        ProxyProvider<UserRds, UserRepository>(
          update: (_, userRds, __) => UserRepository(
            userRds: userRds,
          ),
        ),
      ];

  List<SingleChildWidget> changeNotifiersProviders() => [
        ChangeNotifierProvider<DummyStateHandler>(
          create: (_) => DummyStateHandler(),
        ),
      ];
}
