import 'package:flutter/material.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = true;

  OrderBy orderBy = OrderBy.ascending;
  String? fontSizeLabel = "Medium";
  num fontSize = 2;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchOrderBy(OrderBy od) {
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

  OrderBy getOrderBy() {
    return orderBy;
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
