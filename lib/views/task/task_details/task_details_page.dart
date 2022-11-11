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
  List<bool> isSelected = [false, false, false];

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
          return TextButton(
            onPressed: () =>
                setState(() => isSelected[index] = !isSelected[index]),
            child: Slidable(
              key: ValueKey<String>(lista[index]),
              endActionPane: ActionPane(
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) =>
                        setState(() => isSelected[index] = !isSelected[index]),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icons.check,
                  ),
                  SlidableAction(
                    onPressed: (context) => openModalItem(1, item, context),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                  ),
                  const SlidableAction(
                    onPressed: null,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: ListTile(
                tileColor: isSelected[index] == true
                    ? Colors.blue
                    : Colors.transparent,
                title: Text(item),
              ),
            ),
          );
        },
      ),
    );
  }
}
