import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';

class TslFormField extends StatelessWidget {
  const TslFormField({
    required this.textController,
    required this.onChanged,
    required this.statusStream,
    this.hintText,
    this.emptyFormMessage,
    this.invalidFormMessage,
    this.obscureText,
    this.border,
    this.height,
    this.contentPadding,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  final String? hintText;
  final TextEditingController textController;
  final ValueChanged<String>? onChanged;
  final String? emptyFormMessage;
  final String? invalidFormMessage;
  final bool? obscureText;
  final InputBorder? border;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;

  final Stream<InputStatus> statusStream;

  @override
  Widget build(BuildContext context) => StreamBuilder<InputStatus>(
        stream: statusStream,
        builder: (context, snapshot) {
          final status = snapshot.data ?? InputStatus.valid;

          String? errorText = _parseErrorMessage(status);

          return SizedBox(
            height: height ?? 90,
            child: TextFormField(
              cursorColor: const Color.fromRGBO(49, 45, 84, 1),
              controller: textController,
              obscureText: obscureText == true ? true : false,
              enableSuggestions: obscureText == true ? false : true,
              autocorrect: obscureText == true ? false : true,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 13, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(217, 217, 217, 1),
                border: border ??
                    OutlineInputBorder(
                      borderRadius: borderRadius ?? BorderRadius.circular(30),
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
                contentPadding: contentPadding ??
                    const EdgeInsets.only(
                      left: 20,
                      top: 20,
                      bottom: 20,
                    ),
                errorBorder: OutlineInputBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(30),
                  borderSide: const BorderSide(
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
