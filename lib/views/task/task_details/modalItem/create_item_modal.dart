import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/home/home_model.dart';

class CreateItemModal extends StatefulWidget {
  const CreateItemModal({
    required this.onCreateItemTap,
    super.key,
  });

  final Function(TaskInput input) onCreateItemTap;

  @override
  State<CreateItemModal> createState() => _CreateItemModalState();
}

class _CreateItemModalState extends State<CreateItemModal> {
  final _nameController = TextEditingController();

  final _createTaskFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _createTaskFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Add Item"),
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
                  TextButton(
                    onPressed: () {
                      if (_nameController.text != '' &&
                          _nameController.text != ' ') {
                        null;
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
