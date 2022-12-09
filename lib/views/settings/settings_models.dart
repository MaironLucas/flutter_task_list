import 'package:firebase_auth/firebase_auth.dart';

abstract class SettingsAction {}

class UserInfoChangeSuccessAction extends SettingsAction {}

class UserInfoChangeFailAction extends SettingsAction {}

class OrderByChangeFailAction extends SettingsAction {}

class OrderByChangeSuccessAction extends SettingsAction {}

class ThemePreferenceChangeFailAction extends SettingsAction {}

class ThemePreferenceChangeSuccessAction extends SettingsAction {}

abstract class SettingsState {}

class Loading implements SettingsState {}

class Success implements SettingsState {
  Success({
    required this.user,
    required this.orderBy,
    required this.photoUrl,
    required this.nickname,
  });

  final UserSettingsData user;
  final String orderBy;
  final String photoUrl;
  final String nickname;
}

class Error implements SettingsState {}

enum SubmitStatus {
  valid,
  emailAlreadyUsed,
  invalid,
}

class UserSettingsData {
  UserSettingsData({
    required this.id,
    required this.email,
    required this.name,
  });

  final String id;
  final String email;
  final String name;
}

extension UserToUserData on User {
  UserSettingsData toUserData() => UserSettingsData(
        id: uid,
        email: email!,
        name: displayName!,
      );
}
