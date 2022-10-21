import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/list/lists_bloc.dart';
import 'package:provider/provider.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({
    super.key,
    required this.bloc,
  });

  final ListsBloc bloc;

  static Widget create() => Provider<ListsBloc>(
        create: (_) => ListsBloc(),
        child: Consumer<ListsBloc>(
          builder: (_, bloc, __) => ListsPage(
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return const Material();
  }
}
