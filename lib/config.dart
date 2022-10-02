library config.globals;

import 'package:flutter_task_list/my_theme.dart';
import 'package:flutter/material.dart';

MyTheme currentTheme = MyTheme();

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    hintColor: const Color.fromRGBO(0, 0, 0, 0.5),
    fontFamily: "Inter",
    textTheme: const TextTheme(headline1: TextStyle(fontSize: 20)));

ThemeData light = ThemeData(
    brightness: Brightness.light,
    hintColor: Colors.grey,
    fontFamily: "Inter",
    textTheme: const TextTheme(headline1: TextStyle(fontSize: 20)));
