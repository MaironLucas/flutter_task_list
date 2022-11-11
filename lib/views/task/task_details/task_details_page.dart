import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../home/home_model.dart';
import 'modalItem/create_item_modal.dart';
import 'modalItem/edit_item_modal.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.title});

  final String title;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<String> lista = ["Item 1", "Item 2", "Item 3"];

  void openModalItem(int op, String? title, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: op == 0
              ? CreateItemModal(
                  onCreateItemTap: (TaskInput input) {
                    return null;
                  },
                )
              : EditItemModal(
                  onEditItemTap: (TaskInput input) {
                    null;
                  },
                  title: title!,
                ),
        );
      },
    );
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => openModalItem(0, '', context),
        backgroundColor: Colors.indigoAccent,
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(217, 217, 217, 1),
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
                  onPressed: (context) => openModalItem(1, item, context),
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
