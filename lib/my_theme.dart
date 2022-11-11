import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = true;

  String? orderBy = "Ascending";
  String? fontSizeLabel = "Medium";
  num fontSize = 2;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchOrderBy(String? od) {
    orderBy = od;
    notifyListeners();
  }

  void switchFontSizeLabel(String? od) {
    fontSizeLabel = od;
    if (od == "Small") {
      fontSize = 0;
    } else if (od == "Medium") {
      fontSize = 1;
    } else {
      fontSize = 2;
    }
    notifyListeners();
  }

  void switchTheme(String? od) {
    if (od == "Dark") {
      _isDark = true;
    } else {
      _isDark = false;
    }
    notifyListeners();
  }

  String? getOrderBy() {
    return orderBy;
  }

  bool getOrderByStatus() {
    if (orderBy == "Ascending") {
      return false;
    } else {
      return true;
    }
  }

  String? getFontSizeLabel() {
    return fontSizeLabel;
  }

  double? getFontSize() {
    return fontSize + 0;
  }

  String? getTheme() {
    if (_isDark) {
      return "Dark";
    } else {
      return "Light";
    }
  }
}
