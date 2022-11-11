import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.title});

  final String title;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<String> lista = ["Item 1", "Item 2", "Item 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: lista.length,
        itemBuilder: (context, index) {
          final item = lista[index];
          return Slidable(
            key: ValueKey<String>(item),
            endActionPane: ActionPane(
              motion: const BehindMotion(),
              // dismissible:
              //     DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                const SlidableAction(
                  onPressed: null,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              // onTap: () => Navigator.of(context)
              //     .push(MaterialPageRoute(
              //         builder: (context) => TaskPage(
              //               title: item.name,
              //             ))),
              title: Text(item),
            ),
          );
        },
      ),
    );
  }
}
