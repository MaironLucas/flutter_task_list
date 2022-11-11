enum SubmitStatus {
  valid,
  weakPassword,
  invalid,
}

abstract class EditUserAction {}

class SuccessOnEditUser implements EditUserAction {}

class PopToLogin implements EditUserAction {}

abstract class ButtonState {}

class ButtonLoading implements ButtonState {}

class ButtonActive implements ButtonState {}

class ButtonInactive implements ButtonState {}
