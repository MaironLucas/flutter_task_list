import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/task/list/task_list_models.dart';

class CreateTaskModal extends StatefulWidget {
  const CreateTaskModal({
    required this.onCreateTaskTap,
    super.key,
  });

  final Function(TaskInput input) onCreateTaskTap;

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _createTaskFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _createTaskFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Add Task"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                        child: Text(
                          'Title',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Task title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(217, 217, 217, 1),
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                        child: Text(
                          'Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter Task description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(217, 217, 217, 1),
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (_nameController.text != '' &&
                          _nameController.text != ' ') {
                        widget.onCreateTaskTap(
                          TaskInput(
                              name: _nameController.text,
                              description: _descriptionController.text.trim()),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(200, 60)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.indigoAccent,
                        )),
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
