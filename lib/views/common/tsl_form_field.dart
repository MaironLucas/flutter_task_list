import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';

class TslFormField extends StatelessWidget {
  const TslFormField({
    required this.hintText,
    required this.textController,
    required this.onChanged,
    required this.statusStream,
    this.emptyFormMessage,
    this.invalidFormMessage,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final TextEditingController textController;
  final ValueChanged<String>? onChanged;
  final String? emptyFormMessage;
  final String? invalidFormMessage;

  final Stream<InputStatus> statusStream;

  @override
  Widget build(BuildContext context) => StreamBuilder<InputStatus>(
        stream: statusStream,
        builder: (context, snapshot) {
          final status = snapshot.data ?? InputStatus.valid;

          String? errorText = _parseErrorMessage(status);

          return SizedBox(
            height: 90,
            child: TextFormField(
              cursorColor: const Color.fromRGBO(49, 45, 84, 1),
              controller: textController,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 13, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(217, 217, 217, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                errorText: errorText,
                errorStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 13),
                contentPadding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                  bottom: 20,
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

  String? _parseErrorMessage(InputStatus status) {
    switch (status) {
      case InputStatus.valid:
        return null;
      case InputStatus.empty:
        return emptyFormMessage ?? 'Required field';
      case InputStatus.invalid:
        return invalidFormMessage ?? 'Incorrect value';
      default:
        return '';
    }
  }
}
