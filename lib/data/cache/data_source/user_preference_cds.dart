import 'package:hive/hive.dart';

class UserPreferenceCDS {
  static const _themePreferenceBoxKey = '_themePreferenceBoxKey';
  static const _orderByPreferenceBoxKey = '_orderByPreference';

  Future<String?> getThemePreference() =>
      Hive.openBox<String>(_themePreferenceBoxKey).then(
        (box) => box.get(0),
      );

  Future<void> upsertThemePreference(String themePreference) =>
      Hive.openBox<String>(_themePreferenceBoxKey).then(
        (box) => box.put(0, themePreference),
      );

  Future<void> upsertOrderByPreference(String orderBy) =>
      Hive.openBox<String>(_orderByPreferenceBoxKey)
          .then((box) => box.put(0, orderBy));

  Future<String?> getOrderBy() =>
      Hive.openBox<String>(_orderByPreferenceBoxKey).then(
        (box) => box.get(0),
      );
}
