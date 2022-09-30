abstract class SignInAction {}

class SignInSuccessAction extends SignInAction {}

abstract class ButtonState {}

class ButtonLoading implements ButtonState {}

class ButtonActive implements ButtonState {}

class ButtonInactive implements ButtonState {}

enum SubmitStatus { valid, wrongCredentials }
