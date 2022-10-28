import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Add Task"),
                // Container(
                //   decoration: const BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       color: Colors.transparent),
                //   height: 50,
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 8.0),
                //     child: Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: TextField(
                //           onChanged: (text) {},
                //           cursorColor: Colors.transparent,
                //           decoration: const InputDecoration.collapsed(
                //               hintText: 'Enter task title'),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                        height: 30,
                        child: Text('Title',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
                    TextFormField(
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
                        child: Text('Description',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
                    TextFormField(
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
                  onPressed: () => {},
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
    );
  }
}
