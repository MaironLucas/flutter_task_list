abstract class SignUpAction {}

class SignUpSuccessAction extends SignUpAction {}

abstract class ButtonState {}

class ButtonLoading implements ButtonState {}

class ButtonActive implements ButtonState {}

class ButtonInactive implements ButtonState {}

enum SubmitStatus {
  valid,
  emailAlreadyUsed,
  weakPassword,
  invalid,
}
