import 'package:flutter_task_list/data/cache/data_source/user_preference_cds.dart';

class UserPreferenceRepository {
  UserPreferenceRepository({
    required this.userPreferenceCDS,
  });

  final UserPreferenceCDS userPreferenceCDS;

  Future<void> upsertThemePreference(String themePreference) =>
      userPreferenceCDS.upsertThemePreference(themePreference);

  Future<void> upsertOrderByPreference(String orderBy) =>
      userPreferenceCDS.upsertOrderByPreference(orderBy);

  Future<String?> getThemePreference() =>
      userPreferenceCDS.getThemePreference();

  Future<String?> getOrderBy() => userPreferenceCDS.getOrderBy();
}
