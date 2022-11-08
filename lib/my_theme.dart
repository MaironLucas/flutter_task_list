import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = false;

  String? orderBy = "Ascending";
  String? fontSize = "Medium";

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void switchOrderBy(String? od) {
    orderBy = od;
    notifyListeners();
  }

  void switchFontSize(String? od) {
    fontSize = od;
    notifyListeners();
  }

  String? getOrderBy() {
    return orderBy;
  }

  String? getFontSize() {
    return fontSize;
  }
}
