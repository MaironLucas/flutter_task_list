import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum InputStatus { valid, invalid, empty, error }

enum OrderBy { ascending, descending }

void displaySnackBar(
  BuildContext context,
  String text, {
  EdgeInsets? margin,
}) {
  late Flushbar flush;
  flush = Flushbar(
    margin: margin ?? const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    backgroundColor: const Color.fromARGB(66, 53, 52, 52),
    messageText: FittedBox(
      alignment: Alignment.centerLeft,
      fit: BoxFit.scaleDown,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.25,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    mainButton: TextButton(
      onPressed: () => flush.dismiss(),
      child: const Text(
        'Close',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
          color: Colors.white,
        ),
      ),
    ),
    duration: const Duration(seconds: 4),
  )..show(context);
}
