import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/home/home_model.dart';

class EditTaskModal extends StatefulWidget {
  const EditTaskModal({
    required this.onEditTaskTap,
    required this.title,
    required this.description,
    super.key,
  });

  final Function(TaskInput input) onEditTaskTap;
  final String title;
  final String description;

  @override
  State<EditTaskModal> createState() => _EditTaskModalState();
}

class _EditTaskModalState extends State<EditTaskModal> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.title;
    _descriptionController.text = widget.description;
    super.initState();
  }

  final _editTaskFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 350,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _editTaskFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Edit Task"),
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
                        widget.onEditTaskTap(
                          TaskInput(
                              name: _nameController.text,
                              description: _descriptionController.text),
                        );
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
                        backgroundColor:
                            // buttonStatus is ButtonActive
                            //     ?
                            MaterialStateProperty.all<Color>(
                          Colors.indigoAccent,
                        )
                        // : MaterialStateProperty.all<Color>(
                        //     Colors.blueGrey,
                        //   ),
                        ),
                    child: const Text(
                      "Save",
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
