abstract class LoginState{}

class LoginSuccess implements LoginState{}

class LoginError implements LoginState{}

class LoginLoading implements LoginState{}


abstract class LoginAction{}

class LoginSuccessAction extends LoginAction{}

class LoginErrorAction extends LoginAction {}


abstract class ButtonState{}

class ButtonLoading implements ButtonState{}

class ButtonActive implements ButtonState{}
 
class ButtonInactive implements ButtonState{}
