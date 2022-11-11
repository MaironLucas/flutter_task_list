import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/home/home_model.dart';

class EditUserModal extends StatefulWidget {
  const EditUserModal({super.key, required this.name});

  final String name;

  @override
  State<EditUserModal> createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _createTaskFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController.text = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 450,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _createTaskFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Edit User"),
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
                        'Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
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
                        'Confirm Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
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
                      // widget.onCreateTaskTap(
                      //   TaskInput(
                      //       name: _nameController.text,
                      //       description: _passwordController.text),
                      // );
                    }
                  },
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(200, 60)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
    );
  }
}
