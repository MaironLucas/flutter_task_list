import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/task/task_details/task_details_models.dart';

class CreateItemModal extends StatefulWidget {
  const CreateItemModal({
    required this.onCreateItemTap,
    super.key,
  });

  final Function(CreateStepInput input) onCreateItemTap;

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
                  const Text("Add Step"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                        child: Text(
                          'Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Step name',
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
                        widget.onCreateItemTap(
                          CreateStepInput(
                            name: _nameController.text,
                          ),
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
