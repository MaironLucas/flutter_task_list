import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';

class TslFormField extends StatelessWidget {
  TslFormField({
    required this.hintText,
    required this.textController,
    required this.onChanged,
    required this.statusStream,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final TextEditingController textController;
  final ValueChanged<String>? onChanged;

  final Stream<InputStatus> statusStream;

  @override
  Widget build(BuildContext context) => StreamBuilder<InputStatus>(
      stream: statusStream,
      builder: (context, snapshot) {
        final status = snapshot.data;
        print(status);
        return TextFormField(
          style: TextStyle(fontSize: 12),
          cursorColor: Color.fromRGBO(49, 45, 84, 1),
          controller: textController,
          onChanged: onChanged,
          decoration: InputDecoration.collapsed(
            hintText: 'Email',
            hintStyle: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        );
      });
}
