import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/list/lists_bloc.dart';
import 'package:provider/provider.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({super.key, required this.bloc, required this.tarefas});

  final ListsBloc bloc;

  final List<String> tarefas;

  static Widget create(List<String> tarefas) => Provider<ListsBloc>(
        create: (_) => ListsBloc(),
        child: Consumer<ListsBloc>(
          builder: (_, bloc, __) => ListsPage(
            bloc: bloc,
            tarefas: tarefas,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final item = tarefas[index];

        return ListTile(
          title: Text(item),
          subtitle: Text(item),
        );
      },
    );
  }
}
