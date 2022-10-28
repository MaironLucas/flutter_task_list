library config.globals;

import 'package:flutter_task_list/my_theme.dart';
import 'package:flutter/material.dart';

MyTheme currentTheme = MyTheme();

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    hintColor: const Color.fromARGB(255, 80, 80, 80),
    fontFamily: "Inter",
    textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 20),
        labelSmall: TextStyle(fontWeight: FontWeight.bold)));

ThemeData light = ThemeData(
    brightness: Brightness.light,
    hintColor: const Color.fromARGB(255, 80, 80, 80),
    fontFamily: "Inter",
    textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 20),
        labelSmall: TextStyle(fontWeight: FontWeight.bold)));
